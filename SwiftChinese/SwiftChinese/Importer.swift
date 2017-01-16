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
    var dictionaryExport: DictionaryExport
    
    var newEntries: Int = 0
    var updatedEntries: Int = 0
    var removedEntries: Int = 0
    
    var status: ImportStatus = ImportStatus.Idle
    
    var importQueue = DispatchQueue(label: "com.swiftchinese.import", attributes: .concurrent)
    
    enum ImportStatus {
        case Idle
        case Running
        case Finished
    }
    
    public typealias ImportProgressClosure = (_ totalEntries: Int, _ progressedEntries: Int) -> Void
    public typealias ImportFinishedClosure = (_ error: Error?, _ newEntries: Int, _ updatedEntries: Int, _ removedEntries: Int) -> Void
    
    
    public init(dictionaryExport: DictionaryExport) {
        self.dictionaryExport = dictionaryExport
    }
    
    public func importTranslations(onProgress: @escaping ImportProgressClosure, whenFinished: @escaping ImportFinishedClosure) -> Void {
        self.importQueue.async {
            let context = DataController.sharedInstance.getContext()
            
            let translationArray = self.translationObjects(fromDictionaryString: self.dictionaryExport.content!)
            
            self.beforeImport()
            
            var processingIndex = 0
            
            for translationObject in translationArray {
                // First try to fetch by line hash. If found by hash it means the entry exists and all attributes are identical
                if let _ = Dictionary.sharedInstance.fetchEntryObject(withLineHash: translationObject.lineHash!) {
                    // Exists and up to date
                }
                else {
                    if Dictionary.sharedInstance.fetchEntryObject(forSimplifiedChinese: translationObject.simplifiedChinese) != nil {
                        // The entry exists but some attribute has changed. Update!
                        debugPrint(translationObject)
                        self.updateTranslation(translationObject)
                        self.updatedEntries = self.updatedEntries + 1
                    }
                    else {
                        // The entry doesn't exist. Insert it
                        self.insertTranslation(translationObject)
                        self.newEntries = self.newEntries + 1
                    }
                }
                
                if processingIndex % 100 == 0 {
                    DispatchQueue.main.async {
                        onProgress(self.dictionaryExport.numberOfEntries!, processingIndex)
                    }
                }
                
                // Batch save
                if processingIndex % 1000 == 0 {
                    do {
                        try context.save()
                        debugPrint("Saved")
                    } catch {
                        debugPrint(error)
                    }
                }
                
                processingIndex += 1
            }
            
            // After successful import
            UserDefaults.standard.setValue(self.dictionaryExport.version, forKey: kDictionaryVersion)
            UserDefaults.standard.setValue(self.dictionaryExport.exportDate, forKey: kDictionaryReleaseDate)
            
            // Final save
            do {
                try context.save()
                debugPrint("Saved")
            } catch {
                debugPrint(error)
            }
            
            // Final progress update
            DispatchQueue.main.async {
                onProgress(self.dictionaryExport.numberOfEntries!, processingIndex)
            }
            
            
            self.afterImport()
            
            // TODO: remove CD entities for entries that have been removed from CC-CEDICT
        }
    }
    
    func translationObjects(fromDictionaryString: String) -> [Translation] {
        let lines = fromDictionaryString.components(separatedBy: CharacterSet.newlines)
        
        var translationObjects = [Translation]()
        
        for line in lines {
            // Ingore empty and commented out lines
            if line.characters.first != "#" && line != "" {
                translationObjects.append(Translation(populateFromLine: line))
            }
        }
        
        return translationObjects
    }
    
    func beforeImport() {
        self.status = ImportStatus.Running
        
        self.newEntries = 0
        self.updatedEntries = 0
        self.removedEntries = 0
    }
    
    func afterImport() {
        self.status = ImportStatus.Finished
    }
    
    
    // MARK: - Core data insert/update/delete methods
    
    /// Create and insert entry
    ///
    /// - Parameter translation:
    func insertTranslation(_ translation: Translation) -> Void {
        let context = DataController.sharedInstance.getContext()
        
        let translationEntry = NSEntityDescription.insertNewObject(forEntityName: "TranslationEntry", into: context) as! TranslationEntry
        
        translationEntry.pinyin = translation.pinyin
        translationEntry.simplified = translation.simplifiedChinese
        translationEntry.traditional = translation.traditionalChinese
        
        debugPrint("inserting: " + translationEntry.description)
        
        var englishEntries = Set<EnglishDefinition>()
        
        for englishDefinition in translation.englishDefinitions {
            debugPrint(englishDefinition)
            
            let englishEntry = NSEntityDescription.insertNewObject(forEntityName: "EnglishDefinition", into: context) as! EnglishDefinition
            
            englishEntry.english = englishDefinition
            englishEntries.insert(englishEntry)
        }
        
        translationEntry.inEnglish = englishEntries as NSSet
        
        translationEntry.added = Date() as NSDate
        translationEntry.lineHash = translation.lineHash
        translationEntry.identifierHash = translation.identifierHash
        translationEntry.lastMofified = Date() as NSDate
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
        let englishDefinitions = entry?.inEnglish
        
        guard entry != nil else {
            return
        }
        
        DataController.sharedInstance.getContext().delete(entry!)
        
        if englishDefinitions != nil {
            for englishDefinition in englishDefinitions! {
                DataController.sharedInstance.getContext().delete(englishDefinition as! EnglishDefinition)
            }
        }
    }
}
