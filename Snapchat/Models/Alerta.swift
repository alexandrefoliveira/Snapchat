//
//  Alerta.swift
//  Snapchat
//
//  Created by Alexandre Oliveira on 23/01/2018.
//  Copyright © 2018 Alexandre Oliveira. All rights reserved.
//

import Foundation
import UIKit

class Alerta {
    
    var titulo: String
    var mensagem: String
    
    // Inicializando a Classe
    init(titulo: String , mensagem: String) {
        self.titulo = titulo
        self.mensagem = mensagem
    }
    func getAlerta() -> UIAlertController {
        
        
        // Abaixo escolhe esse método e passo os 2 parametros criados acima titulo e mensagem
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let acaoCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alerta.addAction(acaoCancelar)
        return alerta
        
    }
}
