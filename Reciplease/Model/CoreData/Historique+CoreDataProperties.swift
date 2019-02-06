//
//  Historique+CoreDataProperties.swift
//  Reciplease
//
//  Created by Gregory De knyf on 06/02/2019.
//  Copyright © 2019 De knyf Gregory. All rights reserved.
//
//

import Foundation
import CoreData


extension Historique {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Historique> {
        return NSFetchRequest<Historique>(entityName: "Historique")
    }

    @NSManaged public var ingredient: String

}
