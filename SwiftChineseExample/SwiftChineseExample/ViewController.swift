//
//  ViewController.swift
//  SwiftChineseExample
//
//  Created by Niklas Berglund on 2016-12-02.
//  Copyright © 2016 Klurig. All rights reserved.
//

import UIKit
import SwiftChinese

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let dataController = DataController()
        //let dictionary = SwiftChinese.Dictionary()
        
        print(dataController)
        //dictionary.storeTestEntry()
        
        do {
            let dictionaryExportInfo = try DictionaryExportInfo.latestDictionaryExportInfo()
            let dictionaryExport = DictionaryExport(exportInfo: dictionaryExportInfo!)
            
            dictionaryExport.download(onCompletion: { (exportContent, error) in
                guard error == nil else {
                    debugPrint("Unable to download dictionary info. Aborting.")
                    return
                }
                
                debugPrint(dictionaryExport.hasDownloaded)
                
                let dictionary = Dictionary()
                print("Number of entries in dictionary: " + String(dictionary.numberOfEntries()))
                
                //let someEntryByHash = dictionary.fetchEntryObject(withLineHash: "17d3fd8bf8178dd5dae1680ce7b243b9")
                
                //let someEntryBySimplifiedChinese = dictionary.fetchEntryObject(forSimplifiedChinese: "猫")
                //debugPrint(someEntryBySimplifiedChinese!)
                
                let importer = Importer(dictionaryExport: dictionaryExport)
                importer.importTranslations(onProgress: { (totalEntries, progressedEntries) in
                    debugPrint("progressedEntries: \(progressedEntries), totalEntries: \(totalEntries)")
                }, whenFinished: { (error, newEntries, updatedEntries, removedEntries) in
                    //
                })
            })
        }
        catch let error {
            debugPrint(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
