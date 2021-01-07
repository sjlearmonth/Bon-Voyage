//
//  FeesCalculator.swift
//  Bon Voyage
//
//  Created by Stephen Learmonth on 06/01/2021.
//

import Foundation

class FeesCalculator {
    
    private static let stripeCreditCardCut = 0.029
    private static let flatFeeCents = 30
    
    static func calculateFeesForCard(subTotal: Int) -> Int {
        
        var fees = 0
        if subTotal > 0 {
            fees = Int(Double(subTotal) * stripeCreditCardCut) + flatFeeCents
        }
        return fees
        
    }
    
}
