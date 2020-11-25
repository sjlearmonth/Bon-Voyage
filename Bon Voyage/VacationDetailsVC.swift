//
//  VacationDetailsVC.swift
//  Bon Voyage
//
//  Created by Stephen Learmonth on 08/09/2020.
//

import UIKit
import SDWebImage

class VacationDetailsVC: UIViewController {

    @IBOutlet weak var activitiesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numberOfNightsLabel: UILabel!
    @IBOutlet weak var airFareLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var vacation: Vacation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUi()
        
        setMainImage(index: 0)
        
        setupCollectionView()

    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setMainImage(index: Int) {
        let imageURL = vacation.images[index]
        if let url = URL(string: imageURL) {
            mainImage.layer.cornerRadius = 10
            mainImage.sd_imageIndicator = SDWebImageActivityIndicator.medium
            mainImage.sd_setImage(with: url, placeholderImage: UIImage(named: ImageName.PlaceHolderImage))
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let checkoutVC = segue.destination as? CheckoutVC {
            checkoutVC.vacation = self.vacation
        }
    }
    
    func setupUi() {
        title = vacation.title
        
        activitiesLabel.text = vacation.activities
        descriptionLabel.text = vacation.description
        
        priceLabel.text = "All-inclusive price: " + vacation.price.formatToCurrencyString()
        numberOfNightsLabel.text = "\(vacation.numberOfNights) night accommodations"
        airFareLabel.text = vacation.airFare
    }
}

extension VacationDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        vacation.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let thumbnailCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.ThumbnailCell, for: indexPath) as! ThumbnailCell
        
        let thumbnailURL = vacation.images[indexPath.row]
        thumbnailCell.configureCell(url: thumbnailURL)
        return thumbnailCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        setMainImage(index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 120, height: 120)
    }
    
    
}
