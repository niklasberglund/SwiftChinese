//
//  DictionaryExportInfo.swift
//  SwiftChinese
//
//  Created by Niklas Berglund on 2016-12-13.
//  Copyright © 2016 Klurig. All rights reserved.
//

import Foundation

/// Information about a dictionary export. That is the info about the export extracted from the CC-CEDICT download page.
public class DictionaryExportInfo: NSObject {
    var releaseDate: Date
    var numberOfEntries: Int
    var zipArchiveUrl: URL
    
    public enum ExportInfoError: Error {
        case DownloadInfoFailed
        case ParseHTMLFailed
    }
    
    
    init(releaseDate: Date, numberOfEntries: Int, zipArchive: URL) {
        self.releaseDate = releaseDate
        self.numberOfEntries = numberOfEntries
        self.zipArchiveUrl = zipArchive
    }
    
    public class func latestDictionaryExportInfo() throws -> DictionaryExportInfo? {
        // Official CC-CEDICT download page
        //let downloadPageUrl = URL(string: "https://www.mdbg.net/chindict/chindict.php?page=cedict")!
        
        // Local mirror of download page used for development
        let downloadPageUrl = URL(string: "http://cc-cedict.local/download.html")!
        
        return try self.latestDictionaryExportInfo(fromUrl: downloadPageUrl)
    }
    
    class func latestDictionaryExportInfo(fromUrl: URL) throws -> DictionaryExportInfo? {
        do {
            let downloadPageHtml = try String(contentsOf:fromUrl)
            
            let baseUrl = fromUrl.deletingLastPathComponent()
            let instance = try createInstanceFrom(html: downloadPageHtml, baseUrl:baseUrl)
            
            return instance
        }
        catch ExportInfoError.ParseHTMLFailed {
            throw ExportInfoError.ParseHTMLFailed
        }
        catch {
            throw ExportInfoError.DownloadInfoFailed
        }
    }
    
    class func createInstanceFrom(html: String, baseUrl: URL) throws -> DictionaryExportInfo {
        let scanner = Scanner(string: html)
        
        var latestReleaseResult: NSString?
        let latestReleaseStart = "Latest release: <strong>"
        scanner.scanUpTo(latestReleaseStart, into: nil)
        scanner.scanLocation = scanner.scanLocation + latestReleaseStart.characters.count
        scanner.scanUpTo("</strong>", into: &latestReleaseResult)
        
        var numberOfEntriesResult: NSString?
        var numberOfEntriesStart = "Number of entries: <strong>"
        scanner.scanUpTo(numberOfEntriesStart, into: nil)
        scanner.scanLocation = scanner.scanLocation + numberOfEntriesStart.characters.count
        scanner.scanUpTo("</strong>", into: &numberOfEntriesResult)
        
        var zipArchiveResult: NSString?
        let zipArchiveStart = "<strong><a href=\""
        scanner.scanUpTo(zipArchiveStart, into: nil)
        scanner.scanLocation = scanner.scanLocation + zipArchiveStart.characters.count
        scanner.scanUpTo("\"", into: &zipArchiveResult)
        
        // Set up latest release Date object
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        let latestReleaseDate = dateFormatter.date(from: latestReleaseResult as! String)
        
        // Set up zip archive URL object
        let zipArchiveString = (zipArchiveResult! as String)
        let zipArchiveUrl = baseUrl.appendingPathComponent(zipArchiveString)
        
        // Validate results
        // TODO: better validation
        if latestReleaseResult == nil || numberOfEntriesResult == nil || zipArchiveResult == nil {
            throw ExportInfoError.ParseHTMLFailed
        }
        
        return DictionaryExportInfo(releaseDate: latestReleaseDate!, numberOfEntries: Int(numberOfEntriesResult!.intValue), zipArchive: zipArchiveUrl)
    }
}
