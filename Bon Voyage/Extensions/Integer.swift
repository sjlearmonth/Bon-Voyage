//
//  Integer.swift
//  Bon Voyage
//
//  Created by Stephen Learmonth on 08/09/2020.
//

import Foundation

extension Int {
    
    func formatToCurrencyString() -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        
        let nsNumber = NSNumber(integerLiteral: self / 100)
        return formatter.string(from: nsNumber) ?? "$$$"
    }
    
    func formatToDecimalCurrencyString() -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        
        let nsNumber = NSNumber(integerLiteral: self / 100)
        return formatter.string(from: nsNumber) ?? "$$$"
    }
}
