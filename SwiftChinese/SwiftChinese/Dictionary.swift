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
    enum UpdateStatus {
        case success
        case failure
    }
    
    typealias CompletionClosure = (UpdateStatus) -> Void
    typealias ProgressClosure = (_ current: Int, _ total : Int) -> Void
    
    var dataController = DataController()
    
    /**
    * Update with the latest CC-CEDICT data
    */
    func update(onCompletion:CompletionClosure, onProgress:ProgressClosure) -> Void {
        
    }
    
    public func insert(translation: Translation) -> Void {
        let context = dataController.getContext()
        
        let entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: context) as! Entry
        let chineseEntry = NSEntityDescription.insertNewObject(forEntityName: "ChineseEntry", into: context) as! ChineseEntry
        
        chineseEntry.pinyin = translation.pinyin
        chineseEntry.simplified = translation.simplifiedChinese
        chineseEntry.traditional = translation.traditionalChinese
        
        var englishEntries = Set<EnglishEntry>()
        
        for englishDefinition in translation.englishDefinitions {
            debugPrint(englishDefinition)
            
            let englishEntry = NSEntityDescription.insertNewObject(forEntityName: "EnglishEntry", into: context) as! EnglishEntry
            
            englishEntry.english = englishDefinition
            englishEntries.insert(englishEntry)
        }
        
        entry.inChinese = chineseEntry
        entry.inEnglish = englishEntries as NSSet
        
        entry.added = Date() as NSDate
        entry.entryLineHash = translation.lineHash
        entry.lastMofified = Date() as NSDate
        
        do {
            try context.save()
            print("Saved")
        } catch let error as NSError {
            print(error)
        } catch {
            print("?")
        }
    }
    
    // MARK: - For debugging
    
    public func storeTestEntry() -> Void {
        let context = dataController.getContext()
        
        let entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: context) as! Entry
        let chineseEntry = NSEntityDescription.insertNewObject(forEntityName: "ChineseEntry", into: context) as! ChineseEntry
        let englishEntry = NSEntityDescription.insertNewObject(forEntityName: "EnglishEntry", into: context) as! EnglishEntry
        
        chineseEntry.pinyin = "mao1"
        chineseEntry.simplified = "猫"
        chineseEntry.traditional = "貓"
        
        englishEntry.english = "cat"
        
        var englishSet = Set<EnglishEntry>()
        englishSet.insert(englishEntry)

        entry.inChinese = chineseEntry
        entry.inEnglish = englishSet as NSSet
        
        do {
            try context.save()
            print("Saved")
        } catch let error as NSError {
            print(error)
        } catch {
            print("?")
        }
    }
}
