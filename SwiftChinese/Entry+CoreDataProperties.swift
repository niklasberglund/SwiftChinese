//
//  Entry+CoreDataProperties.swift
//  SwiftChinese
//
//  Created by Niklas Berglund on 2016-12-06.
//  Copyright © 2016 Klurig. All rights reserved.
//  This file was automatically generated and should not be edited.
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
    @NSManaged public var inEnglish: EnglishEntry?

}
