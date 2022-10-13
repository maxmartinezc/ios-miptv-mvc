//
//  UserModel.swift
//  miptvmvc
//
//  Created by Max Martinez Cartagena on 28-03-22.
//

struct UserModel {
    let firstName: String
    let lastName: String
    let playListUrl: String
    
    var fullName: String {
        return firstName + " " + lastName
    }
}
