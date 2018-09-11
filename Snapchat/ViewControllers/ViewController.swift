//
//  ViewController.swift
//  Snapchat
//
//  Created by Alexandre Oliveira on 11/01/2018.
//  Copyright © 2018 Alexandre Oliveira. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Abaixo sera demonstrado como deixar o usuario logado, após ele inserir o email e senha, caso não seja feito esse procedimento, toda vez que ele acessar o app sera solicitado que ele se logue.
            let autenticacao = Auth.auth()
        
        /* Deslogando um usuario.
                do{
                    try autenticacao.signOut()
                }catch{
                    print("Erro ao deslogar usuario")
                }
            */
        
        // Método reponsavel por verificar se o usuario ja se logou e com isso mantem o usuario logado.
        autenticacao.addStateDidChangeListener { (autenticacao, usuario) in
            // Verifico se existe valor para o campo usuario, caso exista defini que temos um usuario logado e o usuario passa direto para a tela principal.
            if let usuarioLogado = usuario{
                self.performSegue(withIdentifier: "loginAutomaticoSegue", sender: nil)
            }
        }
    
    }
    
    // Toda vez que o usuario visualizar a tela esse método sera chamado.
    override func viewWillAppear(_ animated: Bool) {
        // Esse método é utilizado para ocultar ou exibir a barra de navegacao no caso abaixo iremos ocultar.
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

