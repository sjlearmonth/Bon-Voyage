//
//  CardView.swift
//  bon-voyage-alpha
//
//  Created by jonnyb on 8/4/20.
//  Copyright © 2020 jonnybcodes. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 5 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
           didSet {
               self.layer.borderWidth = borderWidth
           }
       }
       
       @IBInspectable var borderColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) {
           didSet {
               self.layer.borderColor = borderColor.cgColor
           }
       }
}
