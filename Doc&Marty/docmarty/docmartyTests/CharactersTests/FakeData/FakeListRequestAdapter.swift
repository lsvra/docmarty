//
//  FakeListRequestAdapter.swift
//  docmartyTests
//
//  Created by Luís Vieira on 08/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

@testable import Doc_Marty
import Foundation

final class FakeListRequestAdapter {}

// MARK: ListRequestAdapterProtocol
extension FakeListRequestAdapter: ListRequestAdapterProtocol {
    
    func characters(page: Int?, name: String?, completion: @escaping (Result<ListData, ServiceError>) -> Void) {
        
        var items: [ConfigurableItem] = []
        var detailItems: [DetailItemData] = []
        
        for i in 0..<20 {
            
            let item = ListCellViewModel(title: "Name_\(i.description)",
                                         imageURL: URL(string: ""))
            items.append(item)
            
            let detailItem = DetailItemData(imageURL: URL(string: ""),
                                            name: "Name_\(i.description)",
                                            gender: "Gender_\(i.description)",
                                            numberOfEpisodes: 0,
                                            locationURL: URL(string: ""),
                                            locationName: "",
                                            locationType: "")
            
            detailItems.append(detailItem)
        }
        
        let data = ListData(items: items, detailItems: detailItems, totalPages: 1)
        
        completion(.success(data))
    }
}
