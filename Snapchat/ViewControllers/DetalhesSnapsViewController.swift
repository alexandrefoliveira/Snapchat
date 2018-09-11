//
//  DetalhesSnapsViewController.swift
//  Snapchat
//
//  Created by Alexandre Oliveira on 30/01/2018.
//  Copyright © 2018 Alexandre Oliveira. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class DetalhesSnapsViewController: UIViewController {

    
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var detalhes: UILabel!
    @IBOutlet weak var contador: UILabel!
    
    var snap = Snap()
    
    // Criando o contador de tempo
    var tempo = 11
    
    override func viewDidLoad() {
        super.viewDidLoad()

       detalhes.text = "Carregando ... "
        
        let url = URL(string: snap.urlImagem)
        imagem.sd_setImage(with: url) { (imagem, erro, cache, url) in
            
            if erro == nil {
           
                self.detalhes.text = self.snap.descricao
                
                // Inicializando o contador
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                    
                    // Decrementar o contador
                    self.tempo = self.tempo - 1
                    
                    // Exibir time na Tela e convertendo numero para String.
                    self.contador.text = String(self.tempo)
                    
                    // Parar de executar o timer quando chegar em 0
                    if self.tempo == 0 {
                        timer.invalidate()
                    
                        // Fechando a tela e voltando para a tela principal.
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                
            }
        }
            
    }
    
    // Método é chamado sempre que a View é fechada ou não esta mais sendo exibida para o Usuário.
    override func viewWillDisappear(_ animated: Bool) {
        
        // Recuperar o Id do usuario logado.
        let autenticacao = Auth.auth()
        if let usuarioLogado = autenticacao.currentUser?.uid {
            // Remove nós do database
            let database = Database.database().reference()
            let usuarios = database.child("usuarios")
            let snaps = usuarios.child(usuarioLogado).child("snaps")
            
            snaps.child(snap.identificador).removeValue()
            
            // Removendo a Imagem do Snap
            let storage = Storage.storage().reference()
            // Estou acenssando o diretorio Imagens do firebase
            let imagens  = storage.child("imagens")
            imagens.child("\(snap.idImagem).jpg").delete(completion: { (erro) in
                
                if erro == nil {
                    print("Sucesso ao excluir Imagem")
                }else{
                    print("Erro ao excluir Imagem")
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
