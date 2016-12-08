//
//  Translation.swift
//  SwiftChinese
//
//  Created by Niklas Berglund on 2016-12-07.
//  Copyright © 2016 Klurig. All rights reserved.
//

import Foundation

public class Translation : NSObject {
    var pinyin : String
    var simplifiedChinese : String
    var traditionalChinese : String
    var englishDefinitions : Array<String>
    
    private var entry : Entry?
    
    init(pinyin: String, simplifiedChinese: String, traditionalChinese: String, englishDefinitions: Array<String>) {
        self.entry = nil
        
        self.pinyin = pinyin
        self.simplifiedChinese = simplifiedChinese
        self.traditionalChinese = traditionalChinese
        self.englishDefinitions = englishDefinitions
    }
    
    init(populateFromLine: String) {
        self.entry = nil
        
        self.pinyin = ""
        self.simplifiedChinese = ""
        self.traditionalChinese = ""
        self.englishDefinitions = []
        
        super.init()
        
        populate(fromLine: populateFromLine)
    }
    
    init(entry : Entry) {
        self.entry = entry
        
        self.pinyin = ""
        self.simplifiedChinese = ""
        self.traditionalChinese = ""
        self.englishDefinitions = []
    }
    
    func populate(fromLine: String) -> Void {
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
        
        var englishDefintionsArray = Array<String>()
        
        while (scanner.isAtEnd == false) {
            var englishDefinition : NSString?
            scanner.scanUpTo("/", into: &englishDefinition)
            scanner.scanLocation = scanner.scanLocation + 1
            englishDefintionsArray.append(englishDefinition as! String)
        }
        
        self.pinyin = pinyin as! String
        self.simplifiedChinese = simplifiedChinese as! String
        self.traditionalChinese = traditionalChinese as! String
        self.englishDefinitions = englishDefintionsArray
        
        //debugPrint(simplifiedChinese!)
        //debugPrint(traditionalChinese!)
        //debugPrint(pinyin!)
        //debugPrint(englishDefinitions)
    }
}
