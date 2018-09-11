//  SnapsViewController.swift
//  Snapchat
//
//  Created by Alexandre Oliveira on 16/01/2018.
//  Copyright © 2018 Alexandre Oliveira. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let totalSnaps = snaps.count
        
        if totalSnaps == 0 {
            return 1
        }
        
        return totalSnaps
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let totalSnaps = snaps.count
        
        if totalSnaps == 0 {
           cell.textLabel?.text = "Nenhum Snap para voce !"
        
        }else{
            let snap = self.snaps [indexPath.row]
            cell.textLabel?.text = snap.nome
        }
        
        
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let totalSnaps = snaps.count
        if totalSnaps > 0 {
            
            let snap = self.snaps [indexPath.row]
            // Caso totalSnaps > 0 , ou seja tenha algum Snap, o usuairo sera direcionado a tela DetahesSnapsViewController para que ele possa visualizar a IMagem e após 10 segundos a imagem sera apagada.
            self.performSegue(withIdentifier: "detalhesSnapsSegue", sender: snap)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalhesSnapsSegue" {
            let detalhesSnapsViewController = segue.destination as! DetalhesSnapsViewController
            
            detalhesSnapsViewController.snap = sender as! Snap
        }
    }
    

    var snaps: [Snap] = []
    
    @IBAction func sair(_ sender: Any) {
        
        
        //Deslogando um usuario.
         let autenticacao = Auth.auth()
        
        do{
            try autenticacao.signOut()
            // Quando o usuario pressionar o botao acima, fecha o Snap e desloga o usuário.
            dismiss(animated: true, completion: nil)
        }catch{
            print("Erro ao deslogar usuario")
        }
      
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Recuperando os dados do usuario logado
        let autenticacao = Auth.auth()
        
        if let idUsuarioLogado = autenticacao.currentUser?.uid {
            
            let database = Database.database().reference()
            let usuarios = database.child("usuarios")
            let snaps = usuarios.child( idUsuarioLogado ).child("snaps")
            
            // Criar um evento para Snaps, sempre que for adicionado um snap seremos notificados.
            snaps.observe(DataEventType.childAdded, with: { (snapshot) in
                
                let dados = snapshot.value as? NSDictionary
                
                let snap = Snap()
               
                snap.identificador = snapshot.key
                snap.nome = dados?["nome"] as! String
                snap.descricao = dados?["descricao"] as! String
                snap.urlImagem = dados?["urlImagem"] as! String
                snap.idImagem = dados?["idImagem"] as! String
            
                
                self.snaps.append( snap )
                
                // Recarregando os dados para exibir que enviou Snaps para voce.
                self.tableView.reloadData()
                
            })
            
            // Sempre que for removido um Snap e voltar para a tela principal a A tableView sera recarregada e sera removido o nome do usuario que enviou.
            snaps.observe(DataEventType.childRemoved, with: { (snapshot) in
                var indice = 0
                for snap in self.snaps {
                    if snap.identificador == snapshot.key {
                        self.snaps.remove(at: indice)
                    }
                    indice = indice + 1
                    
                    // Após executar a delecao acima, devemos recarregar a tabela
                    
                    self.tableView.reloadData()
                }
            })
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



