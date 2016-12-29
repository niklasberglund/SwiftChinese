//
//  Translation.swift
//  SwiftChinese
//
//  Created by Niklas Berglund on 2016-12-07.
//  Copyright © 2016 Klurig. All rights reserved.
//

import Foundation

public class Translation: NSObject {
    var pinyin: String
    var simplifiedChinese: String
    var traditionalChinese: String
    var englishDefinitions: [String]
    var lineHash: String
    
    private var translationEntry: TranslationEntry?
    
    override public var description: String {
        let englishDefinitionsString = englishDefinitions.joined(separator: ", ")
        return "(simplifiedChinese: \(simplifiedChinese), pinyin: \(pinyin), englishDefinitions: [\(englishDefinitionsString)])"
    }
    
    init(populateFromLine: String) {
        self.translationEntry = nil
        
        self.pinyin = ""
        self.simplifiedChinese = ""
        self.traditionalChinese = ""
        self.englishDefinitions = []
        self.lineHash = ""
        
        super.init()
        
        populate(fromLine: populateFromLine)
    }
    
    func populate(fromLine: String) -> Void {
        //debugPrint("fromLine: " + fromLine)
        
        self.lineHash = fromLine.md5()
        
        let scanner = Scanner(string: fromLine)
        
        var simplifiedChinese: NSString?
        scanner.scanUpTo(" ", into:&simplifiedChinese)
        
        var traditionalChinese: NSString?
        scanner.scanUpTo(" ", into: &traditionalChinese)
        
        var pinyin: NSString?
        scanner.scanLocation = scanner.scanLocation + 2 // Step to pinyin
        scanner.scanUpTo("]", into: &pinyin)
        
        // Step to English definitions
        scanner.scanLocation = scanner.scanLocation + 3
        
        var englishDefintionsArray = [String]()
        
        while scanner.isAtEnd == false {
            var englishDefinition: NSString?
            scanner.scanUpTo("/", into: &englishDefinition)
            scanner.scanLocation = scanner.scanLocation + 1
            englishDefintionsArray.append(englishDefinition as! String)
        }
        
        self.pinyin = pinyin as! String
        self.simplifiedChinese = simplifiedChinese as! String
        self.traditionalChinese = traditionalChinese as! String
        self.englishDefinitions = englishDefintionsArray
        
        //debugPrint(self.lineHash)
        //debugPrint(simplifiedChinese!)
        //debugPrint(traditionalChinese!)
        //debugPrint(pinyin!)
        //debugPrint(englishDefinitions)
    }
}
