//
//  Prefetchable.swift
//  docmarty
//
//  Created by Luís Vieira on 06/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import Foundation

protocol Prefetchable {
    var urlsToPrefetch: [URL?] { get }
}
