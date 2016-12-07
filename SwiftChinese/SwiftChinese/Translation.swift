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
    
    init(entry : Entry) {
        self.entry = entry
        
        self.pinyin = ""
        self.simplifiedChinese = ""
        self.traditionalChinese = ""
        self.englishDefinitions = []
    }
}
