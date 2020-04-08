//
//  Details.swift
//  docmarty
//
//  Created by Luís Vieira on 06/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import Foundation

struct DetailItemData {
    
    let imageURL: URL?
    let name: String
    let gender: String
    let numberOfEpisodes: Int
    
    let locationURL: URL?
    let locationName: String?
    var locationType: String?
}

struct DetailData {
    var locationType: String?
}

struct Details {
    
    let imageURL: URL?
    let name: String
    let gender: String
    let numberOfEpisodes: String
    
    let location: String?
}
