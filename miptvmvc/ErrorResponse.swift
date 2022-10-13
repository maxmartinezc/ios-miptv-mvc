//
//  ErrorResponse.swift
//  miptvmvc
//
//  Created by Max Martinez Cartagena on 29-03-22.
//

import Foundation

struct ErrorResponse: Decodable {
    let code: String
    let error: String
    let message: String
}
