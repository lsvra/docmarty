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
}
