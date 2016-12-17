//
//  DataController.swift
//  SwiftChinese
//
//  Created by Niklas Berglund on 2016-12-02.
//  Copyright © 2016 Klurig. All rights reserved.
//

import UIKit
import CoreData

public class DataController: NSObject {
    static let sharedInstance = DataController()
    
    var managedObjectContext: NSManagedObjectContext
    
    public override init() {
        let frameworkBundle = Bundle(for: DataController.self)
        guard let modelURL = frameworkBundle.url(forResource: "DictionaryModel", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = psc
        self.managedObjectContext.undoManager = nil
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docUrl = urls[urls.endIndex-1]
        
        let storeUrl = docUrl.appendingPathComponent("DictionaryModel.sqlite")
        
        do {
            //try FileManager.default.removeItem(at: storeUrl)
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    }
    
    public func getContext() -> NSManagedObjectContext {
        return managedObjectContext
    }
}
