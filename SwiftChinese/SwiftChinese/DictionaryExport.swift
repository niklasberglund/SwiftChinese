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
public class DictionaryExport : NSObject {
    var exportInfo : DictionaryExportInfo
    var content : String?
    
    public var hasDownloaded : Bool {
        get {
            return content != nil
        }
    }
    
    public enum ExportError : Error {
        case DownloadInfoFailed
        case DownloadFailed
        case UnzipFailed
    }
    
    public typealias DownloadCompleteClosure = (_ databaseDump : String?, _ error : ExportError?) -> Void
    
    
    public init(exportInfo : DictionaryExportInfo) {
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
        
        URLSession.shared.downloadTask(with: request, completionHandler: { (dataUrl, response, error) -> Void in
            guard error == nil else {
                onCompletion(nil, ExportError.DownloadFailed)
                return
            }
            
            do {
                let unzipDirPath = NSTemporaryDirectory()
                let unzippedFilePath = unzipDirPath + "cedict_ts.u8"
                SSZipArchive.unzipFile(atPath: dataUrl!.path, toDestination: unzipDirPath)
                
                
                self.content = try String(contentsOfFile: unzippedFilePath, encoding: String.Encoding.utf8)
                onCompletion(self.content, nil) // Success
            }
            catch {
                onCompletion(nil, ExportError.UnzipFailed)
            }
        }).resume()
    }
}
