//
//  ManageBankAccountsVC.swift
//  Bon Voyage
//
//  Created by Stephen Learmonth on 01/03/2021.
//

import UIKit
import LinkKit

class ManageBankAccountsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var banks = [String]()
    var linkHandler: Handler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        banks.append("Stripe Bank")
    }

    @IBAction func addBankAccountClicked(_ sender: Any) {
        presentPlaidLinkUsingLinkToken()
    }
    
}

extension ManageBankAccountsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return banks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bank = banks[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "BankCell")
        cell.textLabel?.text = bank
        return cell
    }
    
    
}
