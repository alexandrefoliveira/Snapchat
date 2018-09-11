//
//  CadastroViewController.swift
//  Snapchat
//
//  Created by Alexandre Oliveira on 12/01/2018.
//  Copyright © 2018 Alexandre Oliveira. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CadastroViewController: UIViewController {
    
    //  Instanciando os campos E-mail, nomeCompleto,senha,Confirmar senha e criarBtn
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var nomeCompleto: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var confirmarSenha: UITextField!
    @IBAction func criarContaBtn(_ sender: Any) {
        
        /* Método para exibir mensagem para o usuario. Passando 2 parametros titulo e mensagem.
         func exibirMensagem(titulo: String , mensagem: String) {
         
         // Abaixo escolhe esse método e passo os 2 parametros criados acima titulo e mensagem
         let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
         let acaoCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
         
         alerta.addAction(acaoCancelar)
         present(alerta, animated: true, completion: nil)
         }
         */
        // Recuperar os dados digitados dos campos Email, Senha e Confirmar Senha
        if let emailRecuperado = self.email.text {
            if let nomecompletoRecuperado = self.nomeCompleto.text{
                if let senhaRecuperada = self.senha.text {
                    if let confirmarSenhaRecuperada = self.confirmarSenha.text{
                        // Validando se os campos de senha e campo de confirmacao de senha são iguais.
                        if senhaRecuperada == confirmarSenhaRecuperada {
                            
                            // Validando se o campo nome esta preenchido para criar a Conta.
                            if nomecompletoRecuperado != ""{
                                
                                // Objeto reponsavel por salvar as contas no Firebase
                                let autenticacao = Auth.auth()
                                autenticacao.createUser(withEmail: emailRecuperado, password: senhaRecuperada, completion: { (usuario, erro) in
                                    if erro == nil {
                                        // Caso o usuario não digite o email, sera exibido a mensagem abaixo
                                        if usuario == nil {
                                            
                                            //exibirMensagem(titulo: "Erro ao autenticar", mensagem: "Problema ao realizar autenticação, favor tente novamente.")
                                            let alerta  = Alerta(titulo: "Upload Falhou", mensagem: "Erro ao salvar o arquivo, tente novamente.")
                                            self.present(alerta.getAlerta(), animated: true, completion: nil)
                                            
                                        }else{
                                            // Fazendo com que os dados do usuario sejam salvos no Firebase.
                                            let database = Database.database().reference()
                                            // Criando o primeiro nó do banco de dados.
                                            let usuarios = database.child("usuarios")
                                            let usuarioDados = ["nome": nomecompletoRecuperado, "email": emailRecuperado]
                                            // Sera criado no Firebase o usuario com um ID.
                                            usuarios.child((usuario?.uid)!).setValue(usuarioDados)
                                            
                                            //redireciona o usuario para a tela principal
                                            self.performSegue(withIdentifier: "cadastroLoginSegue", sender: nil)
                                        }
                                        
                                    }else{
                                        
                                        /* Validando os erros caso o usuario não consiga cadastrar algum usuario.
                                         ERROR_INVALID_EMAIL
                                         ERROR_WEAK_PASSWORD
                                         ERROR_EMAIL_ALREADY_IN_USE
                                         */
                                        
                                        let erroRecuperado = erro! as NSError
                                        
                                        // erroRecuperado.localizedDescription esse método tras qualquer problema que possa aparecer mas estara em ingles, sendo assim irei capturar as mensagens e passa-las para o portugues.
                                        if let codigoErro = erroRecuperado.userInfo["error_name"]{
                                            
                                            let erroTexto = codigoErro as! String
                                            var mensagemErro = ""
                                            
                                            switch erroTexto  {
                                                
                                            case "ERROR_INVALID_EMAIL" :
                                                mensagemErro = "E-mail inválido, digite um e-mail válido"
                                                break
                                            case "ERROR_WEAK_PASSWORD" :
                                                mensagemErro = "Senha precisa ter no minimo 6 caracteres, com letras e numeros"
                                                break
                                            case "ERROR_EMAIL_ALREADY_IN_USE" :
                                                mensagemErro = "Esse e-mail ja esta sendo utilizado, cria sua conta com outro e-mail"
                                                break
                                                
                                            default: mensagemErro = "Dados digitados estão incorretos"
                                                
                                            }
                                            
                                            // exibirMensagem(titulo: "Dados Inválidos", mensagem: mensagemErro)
                                            let alerta  = Alerta(titulo: "Dados Inválidos", mensagem: mensagemErro)
                                            self.present(alerta.getAlerta(), animated: true, completion: nil)
                                        }
                                    }
                                })
                                
                            }else{
                                let alerta  = Alerta(titulo: "Dados Incorretos", mensagem: "Digite seu nome para prosseguir!.")
                                self.present(alerta.getAlerta(), animated: true, completion: nil)
                            }
                            
                        }else{
                            
                            // Chamando o método criado acima para exibir a mensagem para o usuario.
                            //exibirMensagem(titulo: "Dados Incorretos", mensagem: "As senhas não estão iguais, digite novamente.")
                            let alerta  = Alerta(titulo: "Dados Incorretos", mensagem: "As senhas não estão iguais, digite novamente.")
                            self.present(alerta.getAlerta(), animated: true, completion: nil)
                            
                        }
                    }
                }
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // Método abaixo esconde ou exibe a barra de status no caso abaixo, vou exibir
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
