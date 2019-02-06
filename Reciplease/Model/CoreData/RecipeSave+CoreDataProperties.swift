//
//  RecipeSave+CoreDataProperties.swift
//  Reciplease
//
//  Created by Gregory De knyf on 22/01/2019.
//  Copyright © 2019 De knyf Gregory. All rights reserved.
//
//

import Foundation
import CoreData


extension RecipeSave {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeSave> {
        return NSFetchRequest<RecipeSave>(entityName: "RecipeSave")
    }

    @NSManaged public var id: String?
    @NSManaged public var image: Data?
    @NSManaged public var ingredients: String?
    @NSManaged public var likes: String?
    @NSManaged public var name: String?
    @NSManaged public var timeInMinute: String?

}
