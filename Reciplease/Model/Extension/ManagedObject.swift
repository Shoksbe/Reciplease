//
//  ManagedObject.swift
//  Reciplease
//
//  Created by Gregory De knyf on 24/01/2019.
//  Copyright © 2019 De knyf Gregory. All rights reserved.
//

import CoreData

public extension NSManagedObject {
    
    /*
     
     Extension afin d'éviter cette erreur
 
     2019-01-24 17:40:42.171163+0100 Reciplease[61041:3365828] [error] warning: Multiple NSEntityDescriptions claim the NSManagedObject subclass 'Reciplease.RecipeSave' so +entity is unable to disambiguate.
     CoreData: warning: Multiple NSEntityDescriptions claim the NSManagedObject subclass 'Reciplease.RecipeSave' so +entity is unable to disambiguate.
     2019-01-24 17:40:42.171341+0100 Reciplease[61041:3365828] [error] warning:       'RecipeSave' (0x60000051c790) from NSManagedObjectModel (0x6000011200f0) claims 'Reciplease.RecipeSave'.
     CoreData: warning:       'RecipeSave' (0x60000051c790) from NSManagedObjectModel (0x6000011200f0) claims 'Reciplease.RecipeSave'.
     2019-01-24 17:40:42.171476+0100 Reciplease[61041:3365828] [error] warning:       'RecipeSave' (0x60000051db80) from NSManagedObjectModel (0x600001186a80) claims 'Reciplease.RecipeSave'.
     CoreData: warning:       'RecipeSave' (0x60000051db80) from NSManagedObjectModel (0x600001186a80) claims 'Reciplease.RecipeSave'.
     
     */
    
    //https://github.com/drewmccormack/ensembles/issues/275#issuecomment-408710451

    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }
    
}
