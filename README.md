# SwiftChinese
Swift 3 framework for translating between Chinese and English with CC-CEDICT using Core Data. CC-CEDICT is a CC-BY SA 3.0 licensed English - Chinese dictionary database. Read more about it at [https://cc-cedict.org/wiki/](https://cc-cedict.org/wiki/)

## Usage example
### Searching translations
Translations are returned as _Translation_ objects which holds the word in Chinese and English definitions.

#### Search by simplified Chinese
```swift
let dictionary = Dictionary()
let translations: [Translation] = dictionary.translationsFor(simplifiedChinese: "好")
```

#### Search by English definition
```swift
let dictionary = Dictionary()
let translations: [Translation] = dictionary.translationsFor(english: "good")
```

### Importing latest CC-CEDICT data

```swift
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

