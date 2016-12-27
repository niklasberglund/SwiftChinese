//
//  DictionaryExport.swift
//  SwiftChinese
//
//  Created by Niklas Berglund on 2016-12-11.
//  Copyright © 2016 Klurig. All rights reserved.
//

import Foundation
import SSZipArchive

/// Holds a dictionary export's data - the raw dump and also meta info parsed from the dump.
public class DictionaryExport: NSObject {
    var exportInfo: DictionaryExportInfo
    var content: String?
    
    var version: String?
    var numberOfEntries: Int?
    var exportDate: Date?
    
    
    public var hasDownloaded: Bool {
        get {
            return content != nil
        }
    }
    
    public enum ExportError: Error {
        case DownloadInfoFailed
        case DownloadFailed
        case UnzipFailed
    }
    
    public typealias DownloadCompleteClosure = (_ databaseDump: String?, _ error: ExportError?) -> Void
    
    
    public init(exportInfo: DictionaryExportInfo) {
        self.exportInfo = exportInfo
    }

    
    /// Intended for debugging/development only. When developing you can use this initializer instead to initiate from a local CC-CEDICT export file (cedict_ts.u8). This way you don't have to download and unzip it.
    ///
    /// - Parameter localFile: File URL where the unzipped CC-CEDICT export is located(cedict_ts.u8)
    init(localFile: URL) {
        self.exportInfo = DictionaryExportInfo(releaseDate: Date(), numberOfEntries: 123123, zipArchive: URL(string: "http://dummy-domain.com/dummy.zip")!)
        
        do {
            self.content = try String(contentsOf: localFile)
        }
        catch {
            self.content = nil
        }
    }
    
    
    /// Triggers download of this dictionary export. The database export is returned in the `onCompletion` closure and also stored in `self.content`
    ///
    /// - Parameter onCompletion: Closure invoked after download is done, or when it has failed.
    public func download(onCompletion: @escaping DownloadCompleteClosure) -> Void {
        let request = URLRequest(url: self.exportInfo.zipArchiveUrl)
        
        URLSession.shared.downloadTask(with: request, completionHandler: { (dataUrl, _ response, error) -> Void in
            guard error == nil else {
                onCompletion(nil, ExportError.DownloadFailed)
                return
            }
            
            do {
                let unzipDirPath = NSTemporaryDirectory()
                let unzippedFilePath = unzipDirPath + "cedict_ts.u8"
                SSZipArchive.unzipFile(atPath: dataUrl!.path, toDestination: unzipDirPath)
                
                self.content = try String(contentsOfFile: unzippedFilePath, encoding: String.Encoding.utf8)
                
                self.readMetadata()
                
                onCompletion(self.content, nil) // Success
            }
            catch {
                onCompletion(nil, ExportError.UnzipFailed)
            }
        }).resume()
    }
    
    
    /// Read the meta data from this export file
    func readMetadata() -> Void {
        let scanner = Scanner(string: self.content!)
        
        var versionResult: NSString?
        let versionStart = "#! version="
        scanner.scanUpTo(versionStart, into: nil)
        scanner.scanLocation = scanner.scanLocation + versionStart.characters.count
        scanner.scanUpToCharacters(from: CharacterSet.newlines, into: &versionResult)
        
        var subVersionResult: NSString?
        let subVersionStart = "#! subversion="
        scanner.scanUpTo(subVersionStart, into: nil)
        scanner.scanLocation = scanner.scanLocation + subVersionStart.characters.count
        scanner.scanUpToCharacters(from: CharacterSet.newlines, into: &subVersionResult)
        
        var numberOfEntriesResult: NSString?
        let numberOfEntriesStart = "#! entries="
        scanner.scanUpTo(numberOfEntriesStart, into: nil)
        scanner.scanLocation = scanner.scanLocation + numberOfEntriesStart.characters.count
        scanner.scanUpToCharacters(from: CharacterSet.newlines, into: &numberOfEntriesResult)
        
        var exportDateResult: NSString?
        let exportDateStart = "#! date="
        scanner.scanUpTo(exportDateStart, into: nil)
        scanner.scanLocation = scanner.scanLocation + exportDateStart.characters.count
        scanner.scanUpToCharacters(from: CharacterSet.newlines, into: &exportDateResult)
        
        self.version = (versionResult as! String) + "." + (subVersionResult as! String)
        
        self.numberOfEntries = Int(numberOfEntriesResult!.intValue)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        self.exportDate = dateFormatter.date(from: exportDateResult as! String)
    }
}
