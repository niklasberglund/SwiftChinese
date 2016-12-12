//
//  DictionaryExport.swift
//  SwiftChinese
//
//  Created by Niklas Berglund on 2016-12-11.
//  Copyright © 2016 Klurig. All rights reserved.
//

import Foundation
import SSZipArchive

public class DictionaryExport : NSObject {
    var releaseDate : Date
    var numberOfEntries : Int
    var zipArchiveUrl : URL
    var content : String?
    
    public enum ExportError : Error {
        case DownloadFailed
        case UnzipFailed
    }
    
    public typealias DownloadCompleteClosure = (_ databaseDump : String?, _ error : ExportError?) -> Void
    
    
    init(releaseDate: Date, numberOfEntries: Int, zipArchive: URL) {
        self.releaseDate = releaseDate
        self.numberOfEntries = numberOfEntries
        self.zipArchiveUrl = zipArchive
    }
    
    public func download(onCompletion: @escaping DownloadCompleteClosure) -> Void {
        let request = URLRequest(url: self.zipArchiveUrl)
        
        URLSession.shared.downloadTask(with: request, completionHandler: { (dataUrl, response, error) -> Void in
            guard error != nil else {
                onCompletion(nil, ExportError.DownloadFailed)
                return
            }
            
            do {
                let unzipDirPath = NSTemporaryDirectory()
                let unzippedFilePath = unzipDirPath + "cedict_ts.u8"
                SSZipArchive.unzipFile(atPath: dataUrl!.path, toDestination: unzipDirPath)
                
                
                self.content = try String(contentsOfFile: unzippedFilePath, encoding: String.Encoding.utf8)
                onCompletion(self.content, nil)
            }
            catch {
                onCompletion(nil, ExportError.UnzipFailed)
            }
        }).resume()
    }
    
    public class func latestDictionaryExport() -> DictionaryExport? {
        do {
            let downloadPageHtml = try String(contentsOf:URL(string: "https://www.mdbg.net/chindict/chindict.php?page=cedict")!)
            debugPrint(downloadPageHtml)
            
            let scanner = Scanner(string: downloadPageHtml)
            
            var latestReleaseResult : NSString?
            let latestReleaseStart = "Latest release: <strong>"
            scanner.scanUpTo(latestReleaseStart, into: nil)
            scanner.scanLocation = scanner.scanLocation + latestReleaseStart.characters.count
            scanner.scanUpTo("</strong>", into: &latestReleaseResult)
            
            var numberOfEntriesResult : NSString?
            var numberOfEntriesStart = "Number of entries: <strong>"
            scanner.scanUpTo(numberOfEntriesStart, into: nil)
            scanner.scanLocation = scanner.scanLocation + numberOfEntriesStart.characters.count
            scanner.scanUpTo("</strong>", into: &numberOfEntriesResult)
            
            var zipArchiveResult : NSString?
            let zipArchiveStart = "<strong><a href=\""
            scanner.scanUpTo(zipArchiveStart, into: nil)
            scanner.scanLocation = scanner.scanLocation + zipArchiveStart.characters.count
            scanner.scanUpTo("\"", into: &zipArchiveResult)
            
            // Set up latest release Date object
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
            let latestReleaseDate = dateFormatter.date(from: latestReleaseResult as! String)
            
            // Set up zip archive URL object
            let zipArchiveString = "https://www.mdbg.net/chindict/" + (zipArchiveResult! as String)
            let zipArchiveUrl = URL(string: zipArchiveString)
            
            return DictionaryExport(releaseDate: latestReleaseDate!, numberOfEntries: Int(numberOfEntriesResult!.intValue), zipArchive: zipArchiveUrl!)
        }
        catch let error {
            debugPrint(error)
            return nil
        }
    }
}
