# SwiftChinese
Swift 3 framework for translating between Chinese and English with CC-CEDICT using Core Data. CC-CEDICT is a CC-BY SA 3.0 licensed English - Chinese dictionary database. Read more about it at [https://cc-cedict.org/wiki/]().

## What is CC-CEDICT?
From [https://cc-cedict.org/wiki/]():
> CC-CEDICT is a continuation of the CEDICT project. The objective of the CEDICT project was to create an online, downloadable (as opposed to searchable-only) public-domain Chinese-English dictionary. CEDICT was started by Paul Andrew Denisowski in October 1997. For the most part, the project is modeled on Jim Breen's highly successful EDICT (Japanese-English dictionary) project and is intended to be a collaborative effort, with users providing entries and corrections to the main file.

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

