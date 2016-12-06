//
//  EnglishEntry+CoreDataProperties.swift
//  SwiftChinese
//
//  Created by Niklas Berglund on 2016-12-06.
//  Copyright © 2016 Klurig. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension EnglishEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EnglishEntry> {
        return NSFetchRequest<EnglishEntry>(entityName: "EnglishEntry");
    }

    @NSManaged public var english: String?
    @NSManaged public var inEntry: Entry?

}
