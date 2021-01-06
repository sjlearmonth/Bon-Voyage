//
//  ViewController.swift
//  Bon Voyage
//
//  Created by Stephen Learmonth on 01/09/2020.
//

import UIKit
import FirebaseAuth
import Stripe

class HomeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var vacations = [Vacation]()
    var selectedVacation: Vacation?
    
    var paymentContext: STPPaymentContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Vacation Packages"
        vacations = demoData
                
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if user == nil {
                let logInVC = LogInRegisterVC()
                logInVC.modalPresentationStyle = .fullScreen
                self.present(logInVC, animated: true)
            } else {
                UserManager.instance.getCurrentUser {
                    self.setupStripe()
                }
            }
        }

    }
    
    private func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.contentInset.top = 8
        tableView.register(UINib(nibName: CellId.VacationCell, bundle: nil), forCellReuseIdentifier: CellId.VacationCell)
    }

    @IBAction func userIconClicked(_ sender: Any) {
        
        let userActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let logOut = UIAlertAction(title: "Log Out", style: .default) { (action) in
            
            // Logout
            do {
                try Auth.auth().signOut()
            } catch {
                print("DEBUG: \(error.localizedDescription)")
            }
        }
    
        
        let manageCreditCards = UIAlertAction(title: "Manage Credit Cards", style: .default) { (action) in
            // Display Stripe Widget
            self.paymentContext.pushPaymentOptionsViewController()
        }
        
        let manageBankAccounts = UIAlertAction(title: "Manage Bank Accounts", style: .default) { (action) in
            // Display Bank Accounts
        }
        
        let closeAlertAction = UIAlertAction(title: "Close", style: .cancel)
        
        userActionSheet.addAction(logOut)
        userActionSheet.addAction(manageCreditCards)
        userActionSheet.addAction(manageBankAccounts)
        userActionSheet.addAction(closeAlertAction)
        
        present(userActionSheet, animated: true)
    }
    
    func setupStripe() {
        
        Wallet.instance.customerContext = STPCustomerContext(keyProvider: StripeAPIClient())
        
        let config = STPPaymentConfiguration.shared
        paymentContext = STPPaymentContext(customerContext: Wallet.instance.customerContext,
                                           configuration: config,
                                           theme: .defaultTheme)
        
        paymentContext.hostViewController = self
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vacations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId.VacationCell, for: indexPath) as! VacationCell
        cell.configureCell(vacation: vacations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedVacation = vacations[indexPath.row]
        performSegue(withIdentifier: SegueId.ToVacationDetails, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! VacationDetailsVC
        destination.vacation = selectedVacation
    }
}

