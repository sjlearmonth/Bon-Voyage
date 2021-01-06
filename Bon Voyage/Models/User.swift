//
//  User.swift
//  Bon Voyage
//
//  Created by Stephen Learmonth on 06/01/2021.
//

import Foundation

struct User {
    
    var id: String
    var stripeId: String
    var email: String
    
    static func initFrom(_ data: [String: Any]) -> User {
        let id = data["id"] as? String ?? ""
        let stripeId = data["stripeId"] as? String ?? ""
        let email = data["email"] as? String ?? ""
        
        let user = User(id: id, stripeId: stripeId, email: email)
        return user
    }
}
