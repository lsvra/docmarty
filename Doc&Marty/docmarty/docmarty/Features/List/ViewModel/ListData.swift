//
//  ListData.swift
//  docmarty
//
//  Created by Luís Vieira on 06/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

protocol ListDataProtocol {
    var items: [ConfigurableItem] { get }
    var totalPages: Int { get }
}

struct ListData: ListDataProtocol {
    let items: [ConfigurableItem]
    let totalPages: Int
}
