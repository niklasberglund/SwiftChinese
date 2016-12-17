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
    
    public func importTranslations() -> Void {
        let translationArray = translationObjects(fromDictionaryString: self.dictionaryExport.content!)
        
        for translationObject in translationArray {
            // First try to fetch by line hash. If found by hash it means the entry exists and all attributes are identical
            if let _ = Dictionary.sharedInstance.fetchEntryObject(withLineHash: translationObject.lineHash) {
                // Exists and up to date
            }
            else {
                if let entryById = Dictionary.sharedInstance.fetchEntryObject(forSimplifiedChinese: translationObject.simplifiedChinese) {
                    // The entry exists but some attribute has changed. Update!
                }
                else {
                    // The entry doesn't exist. Insert it
                    self.insertTranslation(translationObject)
                }
            }
        }
        
        // After successful import
        UserDefaults.standard.setValue(self.dictionaryExport.version, forKey: kDictionaryVersion)
        UserDefaults.standard.setValue(self.dictionaryExport.exportDate, forKey: kDictionaryReleaseDate)
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
    
    
    // MARK: - Core data insert/update/delete methods
    
    /// Create and insert entry
    ///
    /// - Parameter translation:
    func insertTranslation(_ translation: Translation) -> Void {
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
    
    
    /// Update translation(Entry, ChineseEntry, EnglishEntry)
    ///
    /// - Parameter translation: Translation object with the attribute data to update to
    func updateTranslation(_ translation: Translation) -> Void {
        // First delete the outdated translation, then insert the updated one.
        self.deleteTranslation(translation) // The Translation object is only used for identifying which translation to remove. (translation.simplifiedChinese)
        self.insertTranslation(translation)
    }
    
    
    /// Delete entry
    ///
    /// - Parameter translation: translation to delete(used for identifying the Entry)
    func deleteTranslation(_ translation: Translation) -> Void {
        let entry = Dictionary.sharedInstance.fetchEntryObject(forSimplifiedChinese: translation.simplifiedChinese)
        
        guard entry != nil else {
            return
        }
        
        self.dataController.getContext().delete(entry!)
    }
}
