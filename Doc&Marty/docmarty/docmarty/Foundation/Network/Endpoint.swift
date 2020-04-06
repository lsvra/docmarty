//
//  Endpoint.swift
//  docmarty
//
//  Created by Luís Vieira on 05/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import Foundation

protocol URLBuilder {
    var url: URL? { get }
}

enum Endpoint {
    
    case listCharacters(page: Int)
    
    private var scheme: String {
        return "https"
    }
    
    private var host: String {
        return "rickandmortyapi.com"
    }
    
    private var path: String {
        switch self {
        case .listCharacters:
            return "/api/character/"
        }
    }
    
    private var queryItems: [URLQueryItem] {
        
        switch self {
        case .listCharacters(let page):
            return [URLQueryItem(name: "page", value: page.description)]
        }
    }
}

// MARK: URLBuilder
extension Endpoint: URLBuilder {
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
}
