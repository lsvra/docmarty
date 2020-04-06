//
//  ListModel.swift
//  docmarty
//
//  Created by Luís Vieira on 05/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import Foundation

struct ListModel: Decodable {
    let info: InfoModel
    let results: [CharacterModel]
}
