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
    public func translationsFor(simplifiedChinese: String) -> [Translation] {
        let entryObjects = self.fetchEntryObjects(forSimplifiedChinese: simplifiedChinese)
        
        var translations = [Translation]()
        
        for entry in entryObjects {
            let translationObject = Translation(populateFromEntry: entry)
            translations.append(translationObject)
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
    
    public func fetchEntryObjects(forSimplifiedChinese: String) -> [TranslationEntry] {
        let simplifiedPredicate = NSPredicate(format: "simplified == %@", argumentArray: [forSimplifiedChinese])
        
        return self.fetchEntryObjects(forPredicate: simplifiedPredicate)
    }
    
    public func fetchEntryObjects(forTraditionalChinese: String) -> [TranslationEntry] {
        let traditionalPredicate = NSPredicate(format: "traditional == %@", argumentArray: [forTraditionalChinese])
        
        return self.fetchEntryObjects(forPredicate: traditionalPredicate)
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
