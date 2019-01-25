//
//  String.swift
//  Reciplease
//
//  Created by Gregory De knyf on 25/01/2019.
//  Copyright © 2019 De knyf Gregory. All rights reserved.
//

import Foundation

// MARK: - Extension for String
extension String {
    var containsCharacter: Bool {
        return self.rangeOfCharacter(from: CharacterSet.letters) != nil
    }
}
