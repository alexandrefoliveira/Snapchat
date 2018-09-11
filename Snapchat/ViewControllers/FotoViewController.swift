//
//  FotoViewController.swift
//  Snapchat
//
//  Created by Alexandre Oliveira on 16/01/2018.
//  Copyright © 2018 Alexandre Oliveira. All rights reserved.
//

import UIKit
import FirebaseStorage

class FotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var descricao: UITextField!
    
    // Gerando um identificador, esse método faz com que para cada imagem que seja salva no Firebase seja salvo com um nome diferente.
    var idImagem = NSUUID().uuidString
    
    
    // Trabalhando com fotos, a classe UIImagePickerController, permite que o usuario habilite a camera para tirar um foto ou acesse seu album para esolher uma foto.
    var imagePicker = UIImagePickerController()
    
    @IBAction func selecionarFoto(_ sender: Any) {
        // .savePhotosAlbul, permite escolher as fotos tiradas recentementes salvas no celular. Para usar no celular real, basta trocar o .savePhotosAlbum para .camera
        imagePicker.sourceType = .savedPhotosAlbum
        // Exibindo a imagem selecionada para o usuario.
        present(imagePicker, animated: true, completion: nil)
         
    }
    
    // Metodo para esconder teclado
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    // Sera dado um efeito de esperando para o usuario aguardar realizar o update, portanto foi criado duas referencias para o mesmo botão.
    @IBOutlet weak var btnProximo: UIButton!
    
    // Nesse passo sera desabilitado o botão próximo
    @IBAction func proximoPasso(_ sender: Any) {
        
        // Apenas para deixar o botão proximo como carregando após o usuario clicar em Próximo.
        self.btnProximo.isEnabled = false
        self.btnProximo.setTitle("Carregando...", for: .normal)
        
        let armazenamento = Storage.storage().reference()
        // nessa linha definimos uma pasta dentro do Storage do Firebase, Imagens sera a pasta.
        let imagens = armazenamento.child("imagens")
        
        // Recupera imagens
        if let imagemSelecionada = imagem.image {
            
            // Na linha abaixo sera necessario criar um arquivo.  <#T##compressionQuality: CGFloat##CGFloat#> Devo finir a qualidade da imagem sendo 0 para pequena e 1 alta.
            if let imagensDados = UIImageJPEGRepresentation(imagemSelecionada, 0.5) {
                
                // Para deixar com o self.idImagem , primeiro criar a variavel idImagem do tipo NSUUid().uuidString
                imagens.child("\(self.idImagem).jpg").putData(imagensDados, metadata: nil, completion: { (metaDados, erro) in
                    if erro == nil {
                        print("Sucesso ao fazer upload do arquivo")
                        // a linha abaixo faz com que após subir a imagem para o firebase, eu possa capturar uma URL para que eu possa fazer o download da mesma.
                        let url = (metaDados?.downloadURL()?.absoluteString)
                        
                        // Faz com que eu possa passar da tela de foto para a UsuariosTableViewController
                        self.performSegue(withIdentifier: "selecionarUsuarioSegue", sender: url)
                        
                        self.btnProximo.isEnabled = true
                        self.btnProximo.setTitle("Próximo", for: .normal)
            
                    }else{
                        print("Erro ao fazer upload do arquivo")
                        
                        let alerta  = Alerta(titulo: "Upload Falhou", mensagem: "Erro ao salvar o arquivo, tente novamente.")
                        self.present(alerta.getAlerta(), animated: true, completion: nil)
                    }
                 
                })
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selecionarUsuarioSegue" {
            let usuarioViewController = segue.destination as! UsuariosTableViewController
            // Recuperando a descricao, urlImagem e idImagem
            usuarioViewController.descricao = self.descricao.text!
            usuarioViewController.urlImagem = sender as! String
            usuarioViewController.idImagem = self.idImagem
        }
    }
    
    
    
    
    
    //Método que faz com que eu consiga selecionar a foto ou video e postala no Snap
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let imagemRecuperada = info [UIImagePickerControllerOriginalImage] as! UIImage
        imagem.image = imagemRecuperada
        
        // Habilita o botão próximo no momento que o usuario escolher a foto para clicar no botão próximo
        btnProximo.isEnabled = true
        btnProximo.backgroundColor = UIColor(red: 0.553, green: 0.369, blue: 0.749, alpha: 1)
            
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // A classe FotoViewController que ira controlar essa classe UIImagePickerController por isso deve atribuir o self
        imagePicker.delegate = self
        
        // Desabilitar o botão Próximo até que o usuario selecione uma foto.
        btnProximo.isEnabled = false
        btnProximo.backgroundColor = UIColor.gray
    
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
