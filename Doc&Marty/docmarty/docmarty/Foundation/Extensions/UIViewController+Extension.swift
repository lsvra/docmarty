//
//  UIViewController+Extension.swift
//  docmarty
//
//  Created by Luís Vieira on 06/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func displayError(title: String, message: String ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "error_action_ok".localized,
                                      style: .default,
                                      handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func toggleOfflineScreen(isOnline: Bool) {
        
        navigationController?.setNavigationBarHidden(!isOnline, animated: true)
        
        if isOnline {
            removeViewWithType(type: OfflineView.self)
        } else {
            addViewWithType(type: OfflineView.self)
        }
    }
    
    func toggleLoadingScreen(isLoading: Bool) {
        
        if isLoading {
            addViewWithType(type: LoadingView.self)
        } else {
            removeViewWithType(type: LoadingView.self)
        }
    }
    
    private func addViewWithType<T: UIView>(type: T.Type) {
        
        let view = T()
        view.frame = self.view.frame
        self.view.addSubview(view)
    }
    
    private func removeViewWithType<T: UIView>(type: T.Type) {
        
        let view = self.view.subviews.first(where: { $0 is T })
        view?.removeFromSuperview()
    }
}
