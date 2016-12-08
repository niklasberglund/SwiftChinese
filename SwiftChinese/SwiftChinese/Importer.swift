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
                translationObjects.append(Translation(populateFromLine: line))
                
                // Hard coded limit useful when developing. TODO: remove
                i = i+1;
                if (i > 30) {
                    return translationObjects
                }
            }
        }
        
        return translationObjects
    }
    
}
