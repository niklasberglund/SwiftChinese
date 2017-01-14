//
//  HashType.swift
//  SwiftyHash
//
//  Created by 刘栋 on 2016/7/11.
//  Copyright © 2016年 anotheren.com. All rights reserved.
//

import Foundation
import CommonCrypto

/// Hash Algorithm Type
internal enum HashType {
    
    case md5
    case sha1
    case sha224
    case sha256
    case sha384
    case sha512
    
    /// digest length in byte
    internal var digestLength: Int {
        switch self {
        case .md5:      return Int(CC_MD5_DIGEST_LENGTH)
        case .sha1:     return Int(CC_SHA1_DIGEST_LENGTH)
        case .sha224:   return Int(CC_SHA224_DIGEST_LENGTH)
        case .sha256:   return Int(CC_SHA256_DIGEST_LENGTH)
        case .sha384:   return Int(CC_SHA384_DIGEST_LENGTH)
        case .sha512:   return Int(CC_SHA512_DIGEST_LENGTH)
        }
    }
}

extension HashType {
    
    internal func digest(_ data: Data) -> [UInt8] {
        var hash = [UInt8](repeating: 0, count: digestLength)
        switch self {
        case .md5:
            CC_MD5(data.bytes, CC_LONG(data.count), &hash)
        case .sha1:
            CC_SHA1(data.bytes, CC_LONG(data.count), &hash)
        case .sha224:
            CC_SHA224(data.bytes, CC_LONG(data.count), &hash)
        case .sha256:
            CC_SHA256(data.bytes, CC_LONG(data.count), &hash)
        case .sha384:
            CC_SHA384(data.bytes, CC_LONG(data.count), &hash)
        case .sha512:
            CC_SHA512(data.bytes, CC_LONG(data.count), &hash)
        }
        return hash
    }

    internal func string(_ digest: [UInt8]) -> String {
        var string = ""
        for i in 0..<digestLength {
            string += String(format: "%02x", digest[i])
        }
        return string
    }
    
    internal func string(_ data: Data) -> String {
        return string(digest(data))
    }
}

extension Data {
    
    internal var bytes: Array<UInt8> {
        return Array(self)
    }
}
