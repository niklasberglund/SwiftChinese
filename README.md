# SwiftChinese
Swift 3 framework for translating between Chinese and English with CC-CEDICT using Core Data.

## Usage example

```
do {
    // Latest CC-CEDICT
    let exportInfo = try DictionaryExportInfo.latestDictionaryExportInfo()
    let export = DictionaryExport(exportInfo: exportInfo!)
    
    // Download the dictionary export
    export.download(onCompletion: { (exportContent, error) in
        guard error == nil else {
            debugPrint("Unable to download dictionary export. Aborting.")
            return
        }
        
        // Dictionary object used for getting translations
        let dictionary = Dictionary()
        debugPrint("Number of entries in dictionary before import: " + String(dictionary.numberOfEntries()))
        
        // Do an import
        let importer = Importer(dictionaryExport: export)
        importer.importTranslations(onProgress: { (totalEntries, progressedEntries) in
            // Progress update
            debugPrint("progressedEntries: \(progressedEntries), totalEntries: \(totalEntries)")
        }, whenFinished: { (error, newEntries, updatedEntries, removedEntries) in
            debugPrint("Number of entries in dictionary before import: " + String(dictionary.numberOfEntries()))
        })
    })
}
catch let error {
    debugPrint(error)
}
```

