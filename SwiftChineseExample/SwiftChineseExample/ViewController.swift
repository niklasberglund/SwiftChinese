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
        
        do {
            // Latest CC-CEDICT
            let exportInfo = try DictionaryExportInfo.latestDictionaryExportInfo()
            let export = DictionaryExport(exportInfo: exportInfo!)
            
            export.download(onCompletion: { (exportContent, error) in
                guard error == nil else {
                    debugPrint("Unable to download dictionary export. Aborting.")
                    return
                }
                
                // Dictionary object used for getting translations
                let dictionary = Dictionary()
                print("Number of entries in dictionary before import: " + String(dictionary.numberOfEntries()))
                
                // Do an import
                let importer = Importer(dictionaryExport: export)
                importer.importTranslations(onProgress: { (totalEntries, progressedEntries) in
                    // Progress update
                    debugPrint("progressedEntries: \(progressedEntries), totalEntries: \(totalEntries)")
                }, whenFinished: { (error, newEntries, updatedEntries, removedEntries) in
                    print("Number of entries in dictionary before import: " + String(dictionary.numberOfEntries()))
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
