//
//  Wallet.swift
//  Bon Voyage
//
//  Created by Stephen Learmonth on 06/01/2021.
//

import Foundation
import Stripe

class Wallet {
 
    static let instance = Wallet()
    private init() {}
    
    var customerContext: STPCustomerContext!
    
    
    
}
