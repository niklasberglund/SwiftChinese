//
//  SwiftChineseTests.swift
//  SwiftChineseTests
//
//  Created by Niklas Berglund on 2016-12-02.
//  Copyright © 2016 Klurig. All rights reserved.
//

import XCTest
@testable import SwiftChinese

class SwiftChineseTests: XCTestCase {
    var dataController: DataController = DataController()
    
    override func setUp() {
        super.setUp()
        
        self.dataController = DataController()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetExportInfoPerformance() {
        self.measure {
            do {
                let _ = try DictionaryExportInfo.latestDictionaryExportInfo()
            }
            catch {
                debugPrint(error)
            }
        }
    }
    
    func testSetUpExportPerformance() {
        var dictionaryExportInfo: DictionaryExportInfo?
        
        do {
            dictionaryExportInfo = try DictionaryExportInfo.latestDictionaryExportInfo()
        }
        catch {
            debugPrint(error)
        }
        
        self.measure {
            let _ = DictionaryExport(exportInfo: dictionaryExportInfo!)
        }
    }
    
    /*func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }*/
    
}
