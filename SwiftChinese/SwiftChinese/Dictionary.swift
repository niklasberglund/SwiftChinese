//
//  Dictionary.swift
//  SwiftChinese
//
//  Created by Niklas Berglund on 2016-12-06.
//  Copyright © 2016 Klurig. All rights reserved.
//

import UIKit
import CoreData

class Dictionary: NSObject {
    enum UpdateStatus {
        case success
        case failure
    }
    
    typealias CompletionClosure = (UpdateStatus) -> Void
    typealias ProgressClosure = (_ current: Int, _ total : Int) -> Void
    
    var dataController = DataController()
    
    /**
    * Update with the latest CC-CEDICT data
    */
    func update(onCompletion:CompletionClosure, onProgress:ProgressClosure) -> Void {
        
    }
}
