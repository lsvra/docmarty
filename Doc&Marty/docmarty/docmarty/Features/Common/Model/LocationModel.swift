//
//  LocationModel.swift
//  docmarty
//
//  Created by Luís Vieira on 05/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import Foundation

struct LocationModel: Decodable {
    let name: String
    let type: String?
    let url: String?
}
