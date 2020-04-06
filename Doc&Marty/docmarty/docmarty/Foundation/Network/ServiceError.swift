//
//  Error.swift
//  docmarty
//
//  Created by Luís Vieira on 05/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

enum ServiceError: Error {
    case unknownError
    
    var title: String {
        return "error_title"
    }
    
    var message: String {
        switch self {
        case .unknownError:
            return "error_message_unknown"
        }
    }
}
