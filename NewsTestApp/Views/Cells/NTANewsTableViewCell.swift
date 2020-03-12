//
//  NTANewsTableViewCell.swift
//  NewsTestApp
//
//  Created by Вячеслав on 08/03/2020.
//  Copyright © 2020 PaRaDoX. All rights reserved.
//

import UIKit
import SDWebImage

class NTANewsTableViewCell: UITableViewCell {
    
    @IBOutlet var newsImageView: UIImageView!
    @IBOutlet var newsTitleLabel: UILabel!
    @IBOutlet var newsDescriptionLabel: UILabel!
    @IBOutlet var newsDateLable: UILabel!
    @IBOutlet var loadActivityIndicator: UIActivityIndicatorView!
    
    var viewModel: NTANewsCellViewModel? {
        didSet {
            self.newsTitleLabel.text = viewModel?.newsTitle
            
            loadActivityIndicator.startAnimating()
            self.newsImageView.sd_setImage(with: viewModel?.imageURL,
                                           placeholderImage: UIImage.init(named: "noImage")) { (image, error, cache, url) in
                                            self.loadActivityIndicator.stopAnimating()
            }
            self.newsDescriptionLabel.text = viewModel?.newsDescription
            self.newsDateLable.text = viewModel?.date
        }
    }
    
    
    class func reuseIdentifier() -> String? {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }

    class func nib() -> UINib {
        return UINib(nibName: self.reuseIdentifier() ?? "", bundle: Bundle.main)
    }
}
