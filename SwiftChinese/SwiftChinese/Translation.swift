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
    var english : Array<String>
    
    private var entry : Entry
    
    init(entry : Entry) {
        self.entry = entry
        
        self.pinyin = ""
        self.simplifiedChinese = ""
        self.traditionalChinese = ""
        self.english = []
    }
}
