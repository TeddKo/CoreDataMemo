//
//  MEMOEntity+CoreDataProperties.swift
//  CoreDataMemo
//
//  Created by Ko Minhyuk on 5/28/25.
//
//

import Foundation
import CoreData


extension MEMOEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MEMOEntity> {
        return NSFetchRequest<MEMOEntity>(entityName: "MEMO")
    }

    @NSManaged public var content: String?
    @NSManaged public var insertDate: Date?

}

extension MEMOEntity : Identifiable {

}
