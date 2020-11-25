//
//  ThumbnailCell.swift
//  Bon Voyage
//
//  Created by Stephen Learmonth on 09/09/2020.
//

import UIKit
import SDWebImage

class ThumbnailCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    func configureCell(url: String) {
    
        guard let url = URL(string: url) else { return }
        thumbnailImage.layer.cornerRadius = 5
        thumbnailImage.sd_imageIndicator = SDWebImageActivityIndicator.medium
        thumbnailImage.sd_setImage(with: url, placeholderImage: UIImage(named: ImageName.PlaceHolderImage))
    }
    
}
