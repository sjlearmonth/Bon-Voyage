//
//  CheckoutVC.swift
//  Bon Voyage
//
//  Created by Stephen Learmonth on 16/11/2020.
//

import UIKit

class CheckoutVC: UIViewController {

    @IBOutlet weak var vacationTitle: UILabel!
    @IBOutlet weak var airfareLbl: UILabel!
    @IBOutlet weak var numberOfNightsLbl: UILabel!
    @IBOutlet weak var detailsPriceLbl: UILabel!
    
    @IBOutlet weak var priceLbl:UILabel!
    @IBOutlet weak var processingFeeLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    @IBOutlet weak var selectCardView: UIView!
    @IBOutlet weak var cardIcon: UIImageView!
    @IBOutlet weak var cardEndingIn: UILabel!
    @IBOutlet weak var selectBankView: UIView!
    @IBOutlet weak var bankIcon: UIImageView!
    @IBOutlet weak var bankEndingIn: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var vacation: Vacation!
    var currentlySelectedPaymentType: PaymentType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTapGestures()
        setupUI()
    }
    
    func setupUI() {
        vacationTitle.text = vacation.title
        airfareLbl.text = vacation.airFare
        detailsPriceLbl.text = "All inclusive price: " + vacation.price.formatToCurrencyString()
        numberOfNightsLbl.text = "\(vacation.numberOfNights) night accommodations"
        priceLbl.text = vacation.price.formatToCurrencyString()
    }
    
    func setupTapGestures() {
        let selectCardTouch = UITapGestureRecognizer(target: self, action: #selector(selectCardTapped))
        selectCardView.addGestureRecognizer(selectCardTouch)
        
        let selectBankTouch = UITapGestureRecognizer(target: self, action: #selector(selectBankTapped))
        selectBankView.addGestureRecognizer(selectBankTouch)
    }

    @objc func selectCardTapped() {
        if currentlySelectedPaymentType == .card { return }
        
        currentlySelectedPaymentType = .card
        
        selectCardView.layer.borderColor = UIColor(named: AppColor.BorderBlue)?.cgColor
        selectCardView.layer.borderWidth = 4
        
        selectBankView.layer.borderColor = UIColor.lightGray.cgColor
        selectBankView.layer.borderWidth = 1
        
        cardIcon.tintColor = UIColor(named: AppColor.BorderBlue)
        bankIcon.tintColor = UIColor.lightGray
    }
    
    @objc func selectBankTapped() {
        if currentlySelectedPaymentType == .bank { return }
        
        currentlySelectedPaymentType = .bank
        
        selectCardView.layer.borderColor = UIColor.lightGray.cgColor
        selectCardView.layer.borderWidth = 1
        
        selectBankView.layer.borderColor = UIColor(named: AppColor.BorderBlue)?.cgColor
        selectBankView.layer.borderWidth = 4
        
        cardIcon.tintColor = UIColor.lightGray
        bankIcon.tintColor = UIColor(named: AppColor.BorderBlue)

    }


}

enum PaymentType {
    case card
    case bank
}
