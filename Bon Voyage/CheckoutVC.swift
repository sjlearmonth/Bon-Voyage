//
//  CheckoutVC.swift
//  Bon Voyage
//
//  Created by Stephen Learmonth on 16/11/2020.
//

import UIKit
import FirebaseFunctions
import FirebaseFirestore
import FirebaseAuth
import Stripe

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
    var paymentContext: STPPaymentContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStripe()
        setupTapGestures()
        setupUI()
        setCheckoutLabelDetails()
    }
    
    func setCheckoutLabelDetails() {
        priceLbl.text = "Package Price: \(vacation.price.formatToCurrencyString())"
        let processingFee = FeesCalculator.calculateFeesForCard(subTotal: vacation.price)
        processingFeeLbl.text = "Processing Fee: \(processingFee.formatToCurrencyString())"
        let total = vacation.price + processingFee
        totalLbl.text = "Total: \(total.formatToCurrencyString())"
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

    // MARK: - Select Card
    
    @objc func selectCardTapped() {
        setCardPaymentView()
    }
    
    func setCardPaymentView() {
        if currentlySelectedPaymentType == .card { return }
        
        currentlySelectedPaymentType = .card
        
        selectCardView.layer.borderColor = UIColor(named: AppColor.BorderBlue)?.cgColor
        selectCardView.layer.borderWidth = 4
        
        selectBankView.layer.borderColor = UIColor.lightGray.cgColor
        selectBankView.layer.borderWidth = 1
        
        cardIcon.tintColor = UIColor(named: AppColor.BorderBlue)
        bankIcon.tintColor = UIColor.lightGray
    }
    
    // MARK: - Select Bank
    
    @objc func selectBankTapped() {
        setBankPaymentView()
    }
    
    func setBankPaymentView() {
        if currentlySelectedPaymentType == .bank { return }
        
        currentlySelectedPaymentType = .bank
        
        selectCardView.layer.borderColor = UIColor.lightGray.cgColor
        selectCardView.layer.borderWidth = 1
        
        selectBankView.layer.borderColor = UIColor(named: AppColor.BorderBlue)?.cgColor
        selectBankView.layer.borderWidth = 4
        
        cardIcon.tintColor = UIColor.lightGray
        bankIcon.tintColor = UIColor(named: AppColor.BorderBlue)

    }
    
    func setupStripe() {
        
        // Just make sure that the user has a stripe ID
        guard let _ = UserManager.instance.user?.stripeId else { return }
        
        let config = STPPaymentConfiguration.shared
        paymentContext = STPPaymentContext(customerContext: Wallet.instance.customerContext,
                                           configuration: config,
                                           theme: .defaultTheme)
        
        paymentContext.hostViewController = self
        paymentContext.delegate = self
    }


    @IBAction func changeCardClicked( _ sender: Any) {
        self.paymentContext.pushPaymentOptionsViewController()
    }
    
    @IBAction func changeBankClicked( _ sender: Any) {
        
    }

    @IBAction func payButtonClicked( _ sender: Any) {
        
        let total = vacation.price + FeesCalculator.calculateFeesForCard(subTotal: vacation.price)
        
        let alertController = UIAlertController(title: "Confirm Payment", message: "Confirm payment for \(total.formatToDecimalCurrencyString())", preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "Confirm", style: .default) { (action) in
            self.paymentContext.requestPayment()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(confirm)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }

}

extension CheckoutVC: STPPaymentContextDelegate {
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        // Triggers when the content of the payment context changes, like when the user selects
        // a new payment method or enters shipping information
        if let card = paymentContext.selectedPaymentOption {
            cardEndingIn.text = card.label
        } else {
            cardEndingIn.text = "No Card Selected"
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        simpleAlert(message: "Sorry, but we are not able to load your credit cards at this time")
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        
        // Request Stripe payment intent and return client secret
        
        guard let stripeId = UserManager.instance.user?.stripeId else { return }
        
        let idempotency = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        
        let fees = FeesCalculator.calculateFeesForCard(subTotal: vacation.price)
        let total = vacation.price + fees
        
        let data: [String: Any] = [
            "total": total,
            "idempotency": idempotency,
            "customer_id": stripeId ]
        
        Functions.functions().httpsCallable("createPaymentIntent").call(data) { (result, error) in
            
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                self.simpleAlert(message: "Sorry, but we are not able to complete your payment")
                return
            }
            
            // The client secret can be used to complete a payment from your frontend
            
            guard let clientSecret = result?.data as? String else {
                self.simpleAlert(message: "Sorry, but we are not able to complete your payment")
                return }
            
            // Once the client secret is obtained, create paymentIntentParams
            let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
            paymentIntentParams.paymentMethodId = paymentResult.paymentMethod?.stripeId
            
            // Confirm the PaymentIntent
            STPPaymentHandler.shared().confirmPayment(paymentIntentParams, with: paymentContext) { (status, paymentIntext, error) in
                
                switch status {
                
                case .succeeded:
                    completion(.success, nil)
                    break
                case .failed:
                    completion(.error, nil)
                    break
                case .canceled:
                    completion(.userCancellation, nil)
                    break
                }
            }
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        // Take actioin based on return status: error, success, userCancellation
        switch status {
        
        case .success:
            
            let alertController = UIAlertController(title: "Payment Success", message: "\nYou will receive an email with all the travel details soon! \n\n Bon Voyage", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.navigationController?.popToRootViewController(animated: true)
            }
            alertController.addAction(okAction)
            present(alertController, animated: true)
            
            break
        case .error:
            simpleAlert(message: "Sorry, something went wrong during checkout. You were not charged and can try again.")
            break
        case .userCancellation:
            return
            break
        }
    }
}

enum PaymentType {
    case card
    case bank
}
