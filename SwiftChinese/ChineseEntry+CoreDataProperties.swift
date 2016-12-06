//
//  ChineseEntry+CoreDataProperties.swift
//  SwiftChinese
//
//  Created by Niklas Berglund on 2016-12-06.
//  Copyright © 2016 Klurig. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension ChineseEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChineseEntry> {
        return NSFetchRequest<ChineseEntry>(entityName: "ChineseEntry");
    }

    @NSManaged public var pinyin: String?
    @NSManaged public var simplified: String?
    @NSManaged public var traditional: String?
    @NSManaged public var inEntry: Entry?

}
