//
//  EnglishDefinition+CoreDataProperties.swift
//  SwiftChinese
//
//  Created by Niklas Berglund on 2016-12-27.
//  Copyright © 2016 Klurig. All rights reserved.
//

import Foundation
import CoreData


extension EnglishDefinition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EnglishDefinition> {
        return NSFetchRequest<EnglishDefinition>(entityName: "EnglishDefinition");
    }

    @NSManaged public var english: String?
    @NSManaged public var inTranslationEntry: TranslationEntry?

}
