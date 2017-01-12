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
    
    // MARK: - Search translation entries
    public func translationsFor(entryPredicate: NSPredicate) -> [Translation] {
        let entryObjects = self.fetchEntryObjects(forPredicate: entryPredicate)
        
        return self.translationsFor(entryObjects: entryObjects)
    }
    
    public func translationsFor(simplifiedChinese: String) -> [Translation] {
        let simplifiedPredicate = NSPredicate(format: "simplified == %@", argumentArray: [simplifiedChinese])
        
        return self.translationsFor(entryPredicate: simplifiedPredicate)
    }
    
    public func translationsFor(traditionalChinese: String) -> [Translation] {
        let traditionalPredicate = NSPredicate(format: "traditional == %@", argumentArray: [traditionalChinese])
        
        return self.translationsFor(entryPredicate: traditionalPredicate)
    }
    
    public func translationsFor(english: String) -> [Translation] {
        let englishDefinitions = self.fetchEnglishDefinitionObjects(forEnglish: english)
        
        return self.translationsFor(englishDefinitions: englishDefinitions)
    }
    
    // MARK: - Internal methods for converting from Core Data objects to Translation
    func translationsFor(entryObjects: [TranslationEntry]) -> [Translation] {
        var translations = [Translation]()
        
        for entry in entryObjects {
            let translationObject = Translation(populateFromEntry: entry)
            translations.append(translationObject)
        }
        
        return translations
    }
    
    func translationsFor(englishDefinitions: [EnglishDefinition]) -> [Translation] {
        var translations = [Translation]()
        
        for definition in englishDefinitions {
            let translationEntry = definition.inTranslationEntry
            let translation = Translation(populateFromEntry: translationEntry!)
            translations.append(translation)
        }
        
        return translations
    }
    
    // MARK: - Core Data fetch methods
    func fetchEntryObjects(forPredicate: NSPredicate) -> [TranslationEntry] {
        let fetchRequest: NSFetchRequest<TranslationEntry> = TranslationEntry.fetchRequest()
        fetchRequest.predicate = forPredicate
        
        do {
            let results = try DataController.sharedInstance.getContext().fetch(fetchRequest)
            
            return results
        }
        catch {
            debugPrint(error)
            return []
        }
    }
    
    func fetchEnglishDefinitionObjects(forEnglish: String) -> [EnglishDefinition] {
        let fetchRequest: NSFetchRequest<EnglishDefinition> = EnglishDefinition.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "english == %@", argumentArray: [forEnglish])
        
        do {
            let results = try DataController.sharedInstance.getContext().fetch(fetchRequest)
            
            return results
        }
        catch {
            debugPrint(error)
            return []
        }
    }
    
    public func fetchEntryObject(withLineHash: String) -> TranslationEntry? {
        let lineHashPredicate = NSPredicate(format: "lineHash == %@", argumentArray: [withLineHash])
        
        let entryObjects = self.fetchEntryObjects(forPredicate: lineHashPredicate)
        
        if entryObjects.count > 0 {
            return entryObjects[0]
        }
        else {
            return nil
        }
    }
    
    // TODO: remove this one and use fetchEntryObjects(:) instead. There can be several entries for one character or set of characters.
    @available(*, deprecated, message: "Replacing this with fetchEntryObjects(:)")
    public func fetchEntryObject(forSimplifiedChinese: String) -> TranslationEntry? {
        let translationEntryFetchRequest: NSFetchRequest<TranslationEntry> = TranslationEntry.fetchRequest()
        let simplifiedPredicate = NSPredicate(format: "simplified == %@", argumentArray: [forSimplifiedChinese])
        translationEntryFetchRequest.predicate = simplifiedPredicate
        
        do {
            let results = try DataController.sharedInstance.getContext().fetch(translationEntryFetchRequest)
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
    
    // MARK - Get dictionary info (from Core Data)
    public func numberOfEntries() -> Int {
        let allEntriesFetchRequest: NSFetchRequest<TranslationEntry> = TranslationEntry.fetchRequest()
        
        do {
            let results = try DataController.sharedInstance.getContext().fetch(allEntriesFetchRequest)
            
            return results.count
        }
        catch {
            debugPrint(error)
            return 0
        }
    }
    
    // MARK: - Get dictionary info (from user defaults)
    public func version() -> String? {
        return UserDefaults.standard.object(forKey: kDictionaryVersion) as! String?
    }
    
    public func releaseDate() -> Date? {
        return UserDefaults.standard.object(forKey: kDictionaryReleaseDate) as! Date?
    }
}
