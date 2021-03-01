//
//  PlaidApi.swift
//  Bon Voyage
//
//  Created by Stephen Learmonth on 25/02/2021.
//

import FirebaseFunctions

class PlaidApi {
    
    class func createLinkToken(completion: @escaping (String?) -> () ) {
        
        Functions.functions().httpsCallable("createPlaidLinkToken").call { (result, error) in
            if let error = error {
                debugPrint("Error is \(error.localizedDescription)")
                return completion(nil)
            }
            
            guard let linkToken = result?.data as? String else { return completion(nil) }

            completion(linkToken)
        }
    }
}
