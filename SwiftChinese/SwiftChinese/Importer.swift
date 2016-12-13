//
//  Importer.swift
//  SwiftChinese
//
//  Created by Niklas Berglund on 2016-12-07.
//  Copyright © 2016 Klurig. All rights reserved.
//

import UIKit

public class Importer: NSObject {
    var dictionaryExport : DictionaryExport
    
    public init(dictionaryExport: DictionaryExport) {
        self.dictionaryExport = dictionaryExport
    }
    
    public func insertAllEntries(dictionary: Dictionary) -> Void {
        let translationArray = translationObjects(fromDictionaryString: self.dictionaryExport.content!)
        
        for translation in translationArray {
            dictionary.insert(translation: translation)
        }
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
