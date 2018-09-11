//  UsuariosTableViewController.swift
//  Snapchat
//
//  Created by Alexandre Oliveira on 25/01/2018.
//  Copyright © 2018 Alexandre Oliveira. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class UsuariosTableViewController: UITableViewController {
    
    // Array associado ao arquivo criado chamado Usuario.
    var usuarios: [Usuario] = []
    var urlImagem = ""
    var descricao = ""
    var idImagem = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //Criando referenncia para o banco de Dados
        let database = Database.database().reference()
        
        //Acessando o nó usuarios que acabou de ser criado no Firebase
        let usuarios = database.child("usuarios")
        
        //Captura os dados de todos os usuarios cadastrados no app.
        usuarios.observe(DataEventType.childAdded) { (snapshot) in
            
        // Convertendo os dados de uid, email e nome para um dicionário.
            let dados = snapshot.value as? NSDictionary
            
            // Recupera dados do usuario Logado
            let autenticao = Auth.auth()
            let idUsuarioLogado = autenticao.currentUser?.uid
            
            // Recuperar os dados
            let emailUsuario = dados?["email"] as! String
            let nomeUsuario = dados? ["nome"] as! String
            
            // Para recuperar o snapshot que contem o uid ou ID
            let idUsuario = snapshot.key
            
            // Criando usuario para ser utilizado no Array
            let usuario = Usuario(nome: nomeUsuario, email: emailUsuario, uid: idUsuario)
            
            // Adicionar o usuario criado acima dentro do Array
            if idUsuario != idUsuarioLogado {
                  // Adiciona o usuario dentro do Array.
                  self.usuarios.append(usuario)
            }
            
            // Faz com que seja recerregado os dados do Firebase.
            self.tableView.reloadData()
            
           // print(self.usuarios)
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.usuarios.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        let usuario = self.usuarios[indexPath.row]
        // As duas linhas abaixo exibem o nome e o email do usuarios na tela Usuarios.
        cell.textLabel?.text = usuario.nome
        cell.detailTextLabel?.text = usuario.email
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Recuperando Usuario selecionado para enviar a foto
        let usuarioSelecionado = self.usuarios[indexPath.row]
        let idUsuarioSelecionado = usuarioSelecionado.uid

        //Criando referenncia para o banco de Dados
        let database = Database.database().reference()
        
        //Acessando o nó usuarios que acabou de ser criado no Firebase
        let usuarios = database.child("usuarios")
        
        //Criar um nó unico para cada usuario.
        let snaps = usuarios.child(idUsuarioSelecionado).child("snaps")
        
        //Recuperar dados do usuario logado
        let autenticacao = Auth.auth()
        
        // Ira verificar o Id do usuario logado
        if let idUsuarioLogado = autenticacao.currentUser?.uid {
       
         let usuarioLogado = usuarios.child(idUsuarioLogado)
            usuarioLogado.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                
                let dados = snapshot.value as? NSDictionary
                
                let snap = [
                    
                    "de" : dados? ["email"] as! String,
                    "nome" : dados? ["nome"] as! String ,
                    "descricao" : self.descricao ,
                    "urlImagem" : self.urlImagem ,
                    "idImagem": self.idImagem
                    
                ]
                
                //Criando um identificador unico para um ID, utilizar o childbyAutoID()
                snaps.childByAutoId().setValue(snap)
                
                // To go to the Main ViewController
                self.navigationController?.popToRootViewController(animated: true)
                
            })
     
            
        }
  
        
    
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


 
