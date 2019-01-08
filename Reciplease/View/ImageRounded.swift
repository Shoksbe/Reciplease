//
//  ImageRounded.swift
//  Reciplease
//
//  Created by Gregory De knyf on 03/01/2019.
//  Copyright © 2019 De knyf Gregory. All rights reserved.
//

import UIKit

class ImageRounded: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        layer.cornerRadius = frame.height / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.lightGray.cgColor
    }
}
