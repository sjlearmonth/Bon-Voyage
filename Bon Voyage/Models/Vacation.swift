//
//  Vacation.swift
//  Bon Voyage
//
//  Created by Stephen Learmonth on 04/09/2020.
//

import Foundation

struct Vacation {
    
    let price: Int
    let description: String
    let title: String
    let images: [String]
    let activities: String
    let airFare: String
    let numberOfNights: Int
    
    init( price: Int,
          description: String,
          title: String,
          images: [String],
          activities: String,
          airFare: String,
          numberOfNights: Int) {
        
        self.price = price
        self.description = description
        self.title = title
        self.images = images
        self.activities = activities
        self.airFare = airFare
        self.numberOfNights = numberOfNights
    }
    
    init(data: [String : Any]) {
        self.price = data["price"] as? Int ?? 0
        self.description = data["description"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
        self.images = data["images"] as? [String] ?? [String]()
        self.activities = data["activities"] as? String ?? ""
        self.airFare = data["airFare"] as? String ?? ""
        self.numberOfNights = data["numberOfNights"] as? Int ?? 0
    }
}
