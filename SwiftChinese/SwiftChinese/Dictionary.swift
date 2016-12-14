//
//  Dictionary.swift
//  SwiftChinese
//
//  Created by Niklas Berglund on 2016-12-06.
//  Copyright © 2016 Klurig. All rights reserved.
//

import UIKit
import CoreData

public class Dictionary: NSObject {
    static let sharedInstance = Dictionary()
    
    var dataController = DataController()
    
    // MARK: - Core Data fetch methods
    public func fetchEntryObject(withLineHash: String) -> Entry? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let lineHashPredicate = NSPredicate(format: "lineHash == %@", argumentArray: [withLineHash])
        fetchRequest.predicate = lineHashPredicate
        
        do {
            let results = try dataController.getContext().fetch(fetchRequest)
            debugPrint(results.count)
            
            if results.count > 0 {
                return results[0]
            }
            else {
                return nil
            }
        }
        catch {
            debugPrint(error)
            return nil
        }
    }
    
    public func fetchEntryObject(forSimplifiedChinese: String) -> Entry? {
        let chineseEntryFetchRequest: NSFetchRequest<ChineseEntry> = ChineseEntry.fetchRequest()
        let simplifiedPredicate = NSPredicate(format: "simplified == %@", argumentArray: [forSimplifiedChinese])
        chineseEntryFetchRequest.predicate = simplifiedPredicate
        
        do {
            let results = try dataController.getContext().fetch(chineseEntryFetchRequest)
            debugPrint(results.count)
            
            if results.count > 0 {
                let chineseEntry = results[0]
                let entry = chineseEntry.inEntry
                
                return entry
            }
            else {
                return nil
            }
        }
        catch {
            debugPrint(error)
            return nil
        }
    }
}
