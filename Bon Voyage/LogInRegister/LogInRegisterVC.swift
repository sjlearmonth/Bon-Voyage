//
//  LogInRegisterVC.swift
//  Bon Voyage
//
//  Created by Stephen Learmonth on 03/09/2020.
//

import UIKit
import FirebaseAuth
import FirebaseFunctions
import FirebaseFirestore

class LogInRegisterVC: UIViewController {

    @IBOutlet weak var loginEmailText: UITextField!
    @IBOutlet weak var loginPasswordText: UITextField!
    
    @IBOutlet weak var registerEmailText: UITextField!
    @IBOutlet weak var registerPasswordText: UITextField!
    @IBOutlet weak var registerConfirmPasswordText: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func logInButtonClicked(_ sender: Any) {
        
        guard let email = loginEmailText.text, email.isNotEmpty,
              let password = loginPasswordText.text, password.isNotEmpty else {
            
            simpleAlert(message: "Please fill in all required fields")
            return
        }
        
        activityIndicator.startAnimating()
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            defer {
                self.activityIndicator.stopAnimating()
            }
            
            if let error = error {
                self.simpleAlert(message: error.localizedDescription)
                return
            }
            
            self.dismiss(animated: true)
        }
        
    }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        
        guard let email = registerEmailText.text, email.isNotEmpty,
              let password = registerPasswordText.text, password.isNotEmpty,
              let confirmPassword = registerConfirmPasswordText.text, confirmPassword.isNotEmpty else {
            
            simpleAlert(message: "Please fill in all required fields")
            return
            
        }
        
        if password != confirmPassword {
            
            simpleAlert(message: "Passwords do not match")
            return
        }
        
        activityIndicator.startAnimating()
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            defer {
                self.activityIndicator.stopAnimating()
            }
            
            
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                self.simpleAlert(message: error.localizedDescription)
                return
            }
            
            let log: [String: Any] = [
                "msg": "A new user signed up",
                "timestamp": Timestamp()
            ]
            
            Firestore.firestore().collection("logs").addDocument(data: log) { error in
                if let error = error {
                    print(error)
                } else {
                    print("Log Successfully Added")
                }
            }
            
            // Name it: createStripeCustomer
            Functions.functions().httpsCallable("createStripeCustomer").call( ["email":email,
                                                                               "metadata":[
                                                                                "uid" :  result?.user.uid]]) { (result, error) in
                
                if let error = error {
                    debugPrint("DEBUG: error is \(error.localizedDescription)")
                    return
                }
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
                    
                    if let error = error {
                        debugPrint(error.localizedDescription)
                        return
                    }
                    
                    guard let data = snapshot?.data() else { return }
                    
                    print(data)
                    
                }
                
                self.dismiss(animated: true)
            }
        }
    }
}
