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
        //let dictionary = SwiftChinese.Dictionary()
        
        print(dataController)
        //dictionary.storeTestEntry()
        
        do {
            let dictionaryExport = try DictionaryExport.latestDictionaryExport()
            
            dictionaryExport?.download(onCompletion: { (exportContent, error) in
                debugPrint(exportContent!)
                debugPrint(error!)
                
                debugPrint(dictionaryExport!.hasDownloaded)
            })
        }
        catch let error {
            debugPrint(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

