//
//  CharacterModel.swift
//  docmarty
//
//  Created by Luís Vieira on 05/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import Foundation

struct CharacterModel: Decodable {
    
    let name: String
    let gender: String
    let image: String
    let episode: [String]
    let location: LocationModel?
}




