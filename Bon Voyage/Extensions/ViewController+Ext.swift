//
//  ViewController+Ext.swift
//  Bon Voyage
//
//  Created by Stephen Learmonth on 17/11/2020.
//

import UIKit

extension UIViewController {
    
    func simpleAlert(title: String = "Error", message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}
