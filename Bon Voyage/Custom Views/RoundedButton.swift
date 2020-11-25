//
//  RoundedButton.swift
//  bon-voyage-alpha
//
//  Created by jonnyb on 8/4/20.
//  Copyright © 2020 jonnybcodes. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 5 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    }
}
