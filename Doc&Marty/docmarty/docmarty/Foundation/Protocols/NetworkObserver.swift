//
//  NetworkObserver.swift
//  docmarty
//
//  Created by Luís Vieira on 07/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import Foundation

protocol NetworkObserver {
    
    var reachability: Reachability? { get }
    
    func startNetworkUpdates()
    
    func stopNetworkUpdates()
    
    func networkStatusDidChange()
}

extension NetworkObserver {
    
    func startNetworkUpdates() {
        
        guard let reachability = reachability else { return }
        
        NotificationCenter.default.addObserver(self,
                                               selector: Selector(("networkStatusDidChange")),
                                               name: NSNotification.Name.networkStatusDidChange,
                                               object: nil)
        
        
        try? reachability.start()
    }
    
    func stopNetworkUpdates() {
        
        guard let reachability = reachability else { return }
        
        reachability.stop()
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.networkStatusDidChange,
                                                  object: nil)
    }
}
