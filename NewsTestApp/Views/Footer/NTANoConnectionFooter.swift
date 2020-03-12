//
//  NTANoConnectionFooter.swift
//  NewsTestApp
//
//  Created by Вячеслав on 12/03/2020.
//  Copyright © 2020 PaRaDoX. All rights reserved.
//

import UIKit

class NTANoConnectionFooter: UITableViewHeaderFooterView {
   
    @IBOutlet var retryButton: UIButton!
    
    class func reuseIdentifier() -> String? {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }

    class func nib() -> UINib {
        return UINib(nibName: self.reuseIdentifier() ?? "", bundle: Bundle.main)
    }
}
