//
//  ShadowView.swift
//  Reciplease
//
//  Created by Gregory De knyf on 03/01/2019.
//  Copyright © 2019 De knyf Gregory. All rights reserved.
//

import UIKit

class ShadowView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 6, height: 6)
    }
}
