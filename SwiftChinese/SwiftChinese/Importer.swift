//
//  Importer.swift
//  SwiftChinese
//
//  Created by Niklas Berglund on 2016-12-07.
//  Copyright © 2016 Klurig. All rights reserved.
//

import UIKit
import CoreData

public class Importer: NSObject {
    var dataController : DataController
    var dictionaryExport : DictionaryExport
    
    public init(dictionaryExport: DictionaryExport) {
        self.dataController = DataController()
        self.dictionaryExport = dictionaryExport
    }
    
    public func insertOrUpdate(fromDictionaryExport: DictionaryExport) -> Void {
        let translationArray = translationObjects(fromDictionaryString: self.dictionaryExport.content!)
        
        for translationObject in translationArray {
            self.insert(translation: translationObject)
        }
    }
    
    func translationObjects(fromDictionaryString: String) -> Array<Translation> {
        let lines = fromDictionaryString.components(separatedBy: CharacterSet.newlines)
        
        var translationObjects = Array<Translation>()
        
        var i = 0;
        for line in lines {
            // Ingore empty and commented out lines
            if (line.characters.first != "#" && line != "") {
                translationObjects.append(Translation(populateFromLine: line))
                
                // Hard coded limit useful when developing. TODO: remove
                i = i+1;
                if (i > 30) {
                    return translationObjects
                }
            }
        }
        
        return translationObjects
    }
    
    // MARK: - Core data store methods
    func insert(translation: Translation) -> Void {
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
        entry.lineHash = translation.lineHash
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
}
