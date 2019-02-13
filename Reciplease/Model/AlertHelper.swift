//
//  AlerteHelper.swift
//  Reciplease
//
//  Created by Gregory De knyf on 13/02/2019.
//  Copyright © 2019 De knyf Gregory. All rights reserved.
//

import UIKit

class AlertHelper {
    func alert(_ controller: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        controller.present(alert, animated: true, completion: nil )
    }
}
