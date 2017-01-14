//
//  FileHashCotext.swift
//  SwiftyHash
//
//  Created by 刘栋 on 2016/7/28.
//  Copyright © 2016年 anotheren.com. All rights reserved.
//

import Foundation
import CommonCrypto

internal struct FileHashContext {
    
    /// The Bytes length of the data to read each time
    private let sizeForReadingData: Int = 4096
    
    /// Calculate the file hash string
    ///
    /// - parameter type:     HashType
    /// - parameter filePath: file path
    ///
    /// - returns: hash string
    internal func string(_ type: HashType, path filePath: String) -> String? {
        guard let array: Array<UInt8> = digest(type, path: filePath) else { return nil }
        return type.string(array)
    }
    
    /// Calculate the file hash object
    ///
    /// - parameter type:     HashType
    /// - parameter filePath: file path
    ///
    /// - returns: hash object
    internal func digest(_ type: HashType, path filePath: String) -> Array<UInt8>? {
        guard
            FileManager.default.fileExists(atPath: filePath),
            let fileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, filePath as CFString, .cfurlposixPathStyle, false),
            let readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault, fileURL),
            CFReadStreamOpen(readStream)
            else {
                return nil
        }
        
        var digest = Array<UInt8>(repeating: 0, count: type.digestLength)
        let didSuccess: Bool
        switch type {
        case .md5:
            didSuccess = hashOfFileMD5(pointer: &digest, stream: readStream)
        case .sha1:
            didSuccess = hashOfFileSHA1(pointer: &digest, stream: readStream)
        case .sha224:
            didSuccess = hashOfFileSHA224(pointer: &digest, stream: readStream)
        case .sha256:
            didSuccess = hashOfFileSHA256(pointer: &digest, stream: readStream)
        case .sha384:
            didSuccess = hashOfFileSHA384(pointer: &digest, stream: readStream)
        case .sha512:
            didSuccess = hashOfFileSHA512(pointer: &digest, stream: readStream)
        }
        CFReadStreamClose(readStream)
        
        return didSuccess ? digest : nil
    }
    
    /// Calculate the file‘s md5
    ///
    /// - parameter digestPointer: hash pointer
    /// - parameter readStream:    readable stream object
    ///
    /// - returns: true if success
    private func hashOfFileMD5(pointer digestPointer: UnsafeMutablePointer<UInt8>, stream readStream: CFReadStream) -> Bool {
        var hashObject = CC_MD5_CTX()
        CC_MD5_Init(&hashObject)
        var hasMoreData = true
        while hasMoreData {
            var buffer = Array<UInt8>(repeating: 0, count: sizeForReadingData)
            let readBytesCount = CFReadStreamRead(readStream, &buffer, sizeForReadingData)
            if readBytesCount == -1 {
                break
            } else if readBytesCount == 0 {
                hasMoreData = false
            } else {
                CC_MD5_Update(&hashObject, &buffer, CC_LONG(readBytesCount))
            }
        }
        if hasMoreData { return false }
        CC_MD5_Final(digestPointer, &hashObject)
        return true
    }
    
    /// Calculate the file‘s sha1
    ///
    /// - parameter digestPointer: hash pointer
    /// - parameter readStream:    readable stream object
    ///
    /// - returns: true if success
    private func hashOfFileSHA1(pointer digestPointer: UnsafeMutablePointer<UInt8>, stream readStream: CFReadStream) -> Bool {
        var hashObject = CC_SHA1_CTX()
        CC_SHA1_Init(&hashObject)
        var hasMoreData = true
        while hasMoreData {
            var buffer = Array<UInt8>(repeating: 0, count: sizeForReadingData)
            let readBytesCount = CFReadStreamRead(readStream, &buffer, sizeForReadingData)
            if readBytesCount == -1 {
                break
            } else if readBytesCount == 0 {
                hasMoreData = false
            } else {
                CC_SHA1_Update(&hashObject, &buffer, CC_LONG(readBytesCount))
            }
        }
        if hasMoreData { return false }
        CC_SHA1_Final(digestPointer, &hashObject)
        return true
    }
    
    /// Calculate the file‘s sha224
    ///
    /// - parameter digestPointer: hash pointer
    /// - parameter readStream:    readable stream object
    ///
    /// - returns: true if success
    private func hashOfFileSHA224(pointer digestPointer: UnsafeMutablePointer<UInt8>, stream readStream: CFReadStream) -> Bool {
        var hashObject = CC_SHA256_CTX() // same context struct is used for SHA224 and SHA256
        CC_SHA224_Init(&hashObject)
        var hasMoreData = true
        while hasMoreData {
            var buffer = Array<UInt8>(repeating: 0, count: sizeForReadingData)
            let readBytesCount = CFReadStreamRead(readStream, &buffer, sizeForReadingData)
            if readBytesCount == -1 {
                break
            } else if readBytesCount == 0 {
                hasMoreData = false
            } else {
                CC_SHA224_Update(&hashObject, &buffer, CC_LONG(readBytesCount))
            }
        }
        if hasMoreData { return false }
        CC_SHA224_Final(digestPointer, &hashObject)
        return true
    }
    
    /// Calculate the file‘s sha256
    ///
    /// - parameter digestPointer: hash pointer
    /// - parameter readStream:    readable stream object
    ///
    /// - returns: true if success
    private func hashOfFileSHA256(pointer digestPointer: UnsafeMutablePointer<UInt8>, stream readStream: CFReadStream) -> Bool {
        var hashObject = CC_SHA256_CTX()
        CC_SHA256_Init(&hashObject)
        var hasMoreData = true
        while hasMoreData {
            var buffer = Array<UInt8>(repeating: 0, count: sizeForReadingData)
            let readBytesCount = CFReadStreamRead(readStream, &buffer, sizeForReadingData)
            if readBytesCount == -1 {
                break
            } else if readBytesCount == 0 {
                hasMoreData = false
            } else {
                CC_SHA256_Update(&hashObject, &buffer, CC_LONG(readBytesCount))
            }
        }
        if hasMoreData { return false }
        CC_SHA256_Final(digestPointer, &hashObject)
        return true
    }
    
    /// Calculate the file‘s sha384
    ///
    /// - parameter digestPointer: hash pointer
    /// - parameter readStream:    readable stream object
    ///
    /// - returns: true if success
    private func hashOfFileSHA384(pointer digestPointer: UnsafeMutablePointer<UInt8>, stream readStream: CFReadStream) -> Bool {
        var hashObject = CC_SHA512_CTX() // same context struct is used for SHA384 and SHA512
        CC_SHA384_Init(&hashObject)
        var hasMoreData = true
        while hasMoreData {
            var buffer = Array<UInt8>(repeating: 0, count: sizeForReadingData)
            let readBytesCount = CFReadStreamRead(readStream, &buffer, sizeForReadingData)
            if readBytesCount == -1 {
                break
            } else if readBytesCount == 0 {
                hasMoreData = false
            } else {
                CC_SHA384_Update(&hashObject, &buffer, CC_LONG(readBytesCount))
            }
        }
        if hasMoreData { return false }
        CC_SHA384_Final(digestPointer, &hashObject)
        return true
    }
    
    /// Calculate the file‘s sha512
    ///
    /// - parameter digestPointer: hash pointer
    /// - parameter readStream:    readable stream object
    ///
    /// - returns: true if success
    private func hashOfFileSHA512(pointer digestPointer: UnsafeMutablePointer<UInt8>, stream readStream: CFReadStream) -> Bool {
        var hashObject = CC_SHA512_CTX()
        CC_SHA512_Init(&hashObject)
        var hasMoreData = true
        while hasMoreData {
            var buffer = Array<UInt8>(repeating: 0, count: sizeForReadingData)
            let readBytesCount = CFReadStreamRead(readStream, &buffer, sizeForReadingData)
            if readBytesCount == -1 {
                break
            } else if readBytesCount == 0 {
                hasMoreData = false
            } else {
                CC_SHA512_Update(&hashObject, &buffer, CC_LONG(readBytesCount))
            }
        }
        if hasMoreData { return false }
        CC_SHA512_Final(digestPointer, &hashObject)
        return true
    }
}
