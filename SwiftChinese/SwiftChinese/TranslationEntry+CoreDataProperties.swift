//
//  TranslationEntry+CoreDataProperties.swift
//  SwiftChinese
//
//  Created by Niklas Berglund on 2016-12-27.
//  Copyright © 2016 Klurig. All rights reserved.
//

import Foundation
import CoreData


extension TranslationEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TranslationEntry> {
        return NSFetchRequest<TranslationEntry>(entityName: "TranslationEntry");
    }

    @NSManaged public var added: NSDate?
    @NSManaged public var lastMofified: NSDate?
    @NSManaged public var lineHash: String?
    @NSManaged public var pinyin: String?
    @NSManaged public var simplified: String?
    @NSManaged public var traditional: String?
    @NSManaged public var inEnglish: NSSet?

}

// MARK: Generated accessors for inEnglish
extension TranslationEntry {

    @objc(addInEnglishObject:)
    @NSManaged public func addToInEnglish(_ value: EnglishDefinition)

    @objc(removeInEnglishObject:)
    @NSManaged public func removeFromInEnglish(_ value: EnglishDefinition)

    @objc(addInEnglish:)
    @NSManaged public func addToInEnglish(_ values: NSSet)

    @objc(removeInEnglish:)
    @NSManaged public func removeFromInEnglish(_ values: NSSet)

}
