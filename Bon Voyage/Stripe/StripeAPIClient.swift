//
//  StripeAPIClient.swift
//  Bon Voyage
//
//  Created by Stephen Learmonth on 06/01/2021.
//

import Foundation
import Stripe
import FirebaseFunctions

class StripeAPIClient: NSObject, STPCustomerEphemeralKeyProvider {
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let data = [
            "stripe_version": apiVersion,
            "customer_id": UserManager.instance.user?.stripeId ]
    
        Functions.functions().httpsCallable("createEphemeralKey").call(data) { (result, error) in
            
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return completion(nil, error)
            }
            
            guard let json = result?.data as? [String: Any] else {
                return completion(nil, nil)
            }
            
            completion(json, nil)
        }
    
    
    }
    
    
    
        
}
