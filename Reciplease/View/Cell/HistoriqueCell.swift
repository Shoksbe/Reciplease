//
//  HistoriqueCell.swift
//  Reciplease
//
//  Created by Gregory De knyf on 06/02/2019.
//  Copyright © 2019 De knyf Gregory. All rights reserved.
//

import UIKit

class HistoriqueCell: UICollectionViewCell {
    
    @IBOutlet private weak var label: UILabel!
    
    func setup(_ string: String) {
        label.text = string
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.isSelected = false
    }
    
}
