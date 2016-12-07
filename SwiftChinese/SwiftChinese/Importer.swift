//
//  Importer.swift
//  SwiftChinese
//
//  Created by Niklas Berglund on 2016-12-07.
//  Copyright © 2016 Klurig. All rights reserved.
//

import UIKit

public class Importer: NSObject {
    var dictionaryString : String
    
    public init(forDictionaryAtUrl: URL) {
        do {
            self.dictionaryString = try String(contentsOf: forDictionaryAtUrl, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            debugPrint(error)
            self.dictionaryString = ""
        }
    }
    
    public func insertAllEntries() -> Void {
        debugPrint(translationObjects(fromDictionaryString: self.dictionaryString))
    }
    
    func translationObjects(fromDictionaryString: String) -> Array<Translation> {
        let lines = fromDictionaryString.components(separatedBy: CharacterSet.newlines)
        
        var translationObjects = Array<Translation>()
        
        var i = 0;
        for line in lines {
            // Ingore empty and commented out lines
            if (line.characters.first != "#" && line != "") {
                translationObjects.append(translationObject(fromLine: line))
                
                // Hard coded limit useful when developing. TODO: remove
                i = i+1;
                if (i > 30) {
                    return translationObjects
                }
            }
        }
        
        return translationObjects
    }
    
    func translationObject(fromLine: String) -> Translation {
        debugPrint("fromLine: " + fromLine)
        let scanner = Scanner(string: fromLine)
        
        var simplifiedChinese : NSString?
        scanner.scanUpTo(" ", into:&simplifiedChinese)
        
        var traditionalChinese : NSString?
        scanner.scanUpTo(" ", into: &traditionalChinese)
        
        var pinyin : NSString?
        scanner.scanLocation = scanner.scanLocation + 2 // Step to pinyin
        scanner.scanUpTo("]", into: &pinyin)
        
        // Step to English definitions
        scanner.scanLocation = scanner.scanLocation + 3
        
        var englishDefintions = Array<String>()
        
        while (scanner.isAtEnd == false) {
            var englishDefinition : NSString?
            scanner.scanUpTo("/", into: &englishDefinition)
            scanner.scanLocation = scanner.scanLocation + 1
            englishDefintions.append(englishDefinition as! String)
        }
        
        //debugPrint(simplifiedChinese!)
        //debugPrint(traditionalChinese!)
        //debugPrint(pinyin!)
        //debugPrint(englishDefinitions)
        
        let translation = Translation(
            pinyin: pinyin as! String,
            simplifiedChinese: simplifiedChinese as! String,
            traditionalChinese: traditionalChinese as! String,
            englishDefinitions: englishDefintions
        )
        
        return translation
    }
    
}
