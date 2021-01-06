//
//  FeesCalculator.swift
//  Bon Voyage
//
//  Created by Stephen Learmonth on 06/01/2021.
//

import Foundation

class FessCalculator {
    
    private static let stripeCreditCardCut = 0.029
    private static let flatFeeCents = 30
    
    static func calculateFeesForCard(subTotal: Int) -> Int {
        
        if subTotal == 0 {
            return 0
        }
        
        // vacation = 999
        let fees = Int(Double(subTotal) + stripeCreditCardCut) + flatFeeCents
        
        return fees
    }
    
}
