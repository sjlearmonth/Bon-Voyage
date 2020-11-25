//
//  VacationCell.swift
//  Bon Voyage
//
//  Created by Stephen Learmonth on 04/09/2020.
//

import UIKit
import SDWebImage

class VacationCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize.zero
    }

    func configureCell(vacation: Vacation) {
        titleLabel.text = vacation.title
        priceLabel.text = vacation.price.formatToCurrencyString()
        
        let imageURL = vacation.images[0]
        if let url = URL(string: imageURL) {
            mainImage.sd_imageIndicator = SDWebImageActivityIndicator.medium
            mainImage.sd_setImage(with: url, placeholderImage: UIImage(named: ImageName.PlaceHolderImage))
        }
    }
    
}
