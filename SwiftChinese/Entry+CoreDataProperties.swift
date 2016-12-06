//
//  Entry+CoreDataProperties.swift
//  SwiftChinese
//
//  Created by Niklas Berglund on 2016-12-07.
//  Copyright © 2016 Klurig. All rights reserved.
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry");
    }

    @NSManaged public var added: NSDate?
    @NSManaged public var mofified: NSDate?
    @NSManaged public var inChinese: ChineseEntry?
    @NSManaged public var inEnglish: NSSet?

}

// MARK: Generated accessors for inEnglish
extension Entry {

    @objc(addInEnglishObject:)
    @NSManaged public func addToInEnglish(_ value: EnglishEntry)

    @objc(removeInEnglishObject:)
    @NSManaged public func removeFromInEnglish(_ value: EnglishEntry)

    @objc(addInEnglish:)
    @NSManaged public func addToInEnglish(_ values: NSSet)

    @objc(removeInEnglish:)
    @NSManaged public func removeFromInEnglish(_ values: NSSet)

}
