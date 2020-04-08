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
    
    case characters(page: Int?, name: String?)
    
    private var scheme: String {
        return "https"
    }
    
    private var host: String {
        return "rickandmortyapi.com"
    }
    
    private var path: String {
        switch self {
        case .characters:
            return "/api/character/"
        }
    }
    
    private var queryItems: [URLQueryItem]? {
        
        switch self {
        case .characters(let page, let name):
            
            var queryItems: [URLQueryItem] = []
            
            if let page = page {
                queryItems.append(URLQueryItem(name: "page", value: page.description))
            }
            
            if let name = name {
                queryItems.append(URLQueryItem(name: "name", value: name))
            }
            
            return queryItems
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
