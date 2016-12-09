//
//  ViewController.swift
//  SwiftChineseExample
//
//  Created by Niklas Berglund on 2016-12-02.
//  Copyright © 2016 Klurig. All rights reserved.
//

import UIKit
import SwiftChinese

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let dataController = DataController()
        let dictionary = SwiftChinese.Dictionary()
        
        print(dataController)
        dictionary.storeTestEntry()
        
        let dictionaryUrl = URL(fileURLWithPath: "/Users/niklas/Downloads/cedict_ts.u8-3")
        let importer = Importer(forDictionaryAtUrl: dictionaryUrl)
        importer.insertAllEntries(dictionary: dictionary)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

