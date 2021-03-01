//
//  PlaidExtension.swift
//  Bon Voyage
//
//  Created by Stephen Learmonth on 01/03/2021.
//

import Foundation
import LinkKit
import FirebaseFunctions

extension ManageBankAccountsVC {
    
    func presentPlaidLinkUsingLinkToken() {
        PlaidApi.createLinkToken { [weak self] token in
            guard let _ = self else { return }
            guard let token = token, token.isNotEmpty else { return }
            
            /// The designated initializer for `LinkTokenConfiguration`.
            ///
            /// - Parameters:
            ///   - token: The token to use when communicating with Plaid's backend API
            ///   - onSuccess: Called when the flow finished successfully

            var linkConfiguration = LinkTokenConfiguration(token: token, onSuccess: { (success) in
                print("DEBUG: \(success.publicToken)")
                print("DEBUG: \(success.metadata)")
            })
            
            linkConfiguration.onExit = { exit in
                if let error = exit.error {
                    debugPrint("DEBUG: error is \(error.localizedDescription), metadata is \(exit.metadata)")
                } else {
                    debugPrint("DEBUG: metadata is \(exit.metadata)")
                }
            }
            /// Create a new handler to integrate Plaid Link for iOS.
            /// - Parameter linkTokenConfiguration: Configures the created Plaid Link for a specific use-case or flow.
            /// - Returns: a `Result` that either contains a `Handler` to present Plaid Link or a `CreateError` with details of what went wrong.
            
            let presenter = Plaid.create(linkConfiguration)
            switch presenter {
            case .failure(let error):
            debugPrint(error.localizedDescription)
                self?.simpleAlert(message: error.localizedDescription)
            case .success(let handler):
                handler.open(presentUsing: .viewController(self!))
                self?.linkHandler = handler
            }
        }
    }
    
    func handleSuccessWithToken(_ publicToken: String, metadata: SuccessMetadata) {
        
    }
    
    
}
