//
//  ApiError.swift
//  miptvmvc
//
//  Created by Max Martinez Cartagena on 03-10-22.
//

import Foundation

enum ApiError: Error {
    case badRequest(error: ErrorResponse)
    case invalidUserOrPassword(error: ErrorResponse)
    case internalServerError(error: ErrorResponse)
}

extension ApiError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badRequest(let error):
            return NSLocalizedString(error.message, comment: error.code)
            
        case .invalidUserOrPassword(let error):
            return NSLocalizedString(error.message, comment: error.code)

        case .internalServerError(let error):
            return NSLocalizedString(error.message, comment: error.code)
        }
    }
}
