//
//  EntrarViewController.swift
//  Snapchat
//
//  Created by Alexandre Oliveira on 12/01/2018.
//  Copyright © 2018 Alexandre Oliveira. All rights reserved.
//

import UIKit
import FirebaseAuth

class EntrarViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBAction func entrarButton(_ sender: Any) {
    
    // Validar os dados inseridos nos campos email e senha.
        if let emailRecuperado = self.email.text{
            if let senhaRecuperada = self.senha.text{
                // Autenticacao do usuario no Firebase
                let autenticacao = Auth.auth()
                // Autenticando o usuario com email
                autenticacao.signIn(withEmail: emailRecuperado, password: senhaRecuperada, completion: { (usuario, erro) in
                    if erro == nil {
                        
                        if usuario == nil {
                        self.exibirMensagem(titulo: "Erro ao autenticar", mensagem: "Problema ao realizar autenticacao, tente novamente")
                    
                        }else{
                            //redireciona o usuario para a tela principal
                            self.performSegue(withIdentifier: "loginUsuarioSegue", sender: nil)
                        }
                    
                    }else{
                       // self.exibirMensagem(titulo: "Dados incorretos", mensagem: "Favor, verifique os dados digitados e tente novamente.")
                        let alerta  = Alerta(titulo: "Dados incorretos", mensagem: "Favor, verifique os dados digitados e tente novamente.")
                        self.present(alerta.getAlerta(), animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
    // Método para exibir mensagem para o usuario. Passando 2 parametros titulo e mensagem.
    func exibirMensagem(titulo: String , mensagem: String) {
        
        // Abaixo escolhe esse método e passo os 2 parametros criados acima titulo e mensagem
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let acaoCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alerta.addAction(acaoCancelar)
        present(alerta, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    // Toda vez que o usuario visualizar a tela esse método sera chamado.
    override func viewWillAppear(_ animated: Bool) {
        // Esse método é utilizado para ocultar ou exibir a barra de navegacao no caso abaixo iremos exibir.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
