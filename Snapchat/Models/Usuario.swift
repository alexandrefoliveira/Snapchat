//
//  Usuario.swift
//  Snapchat
//
//  Created by Alexandre Oliveira on 26/01/2018.
//  Copyright © 2018 Alexandre Oliveira. All rights reserved.
//

import Foundation

class Usuario {
    
    var nome: String
    var email: String
    var uid: String
    
    init(nome: String ,email: String , uid: String ) {
        self.email = email
        self.nome = nome
        self.uid = uid
    }
}


