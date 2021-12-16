//
//  Hash.swift
//  Google Auth
//
//  Created by NEKLEENOV Ilya on 15.09.2021.
//

import Foundation
import CommonCrypto

extension Data {
    public func hmacSha1(key: Data) -> String {
        let keyPointer = (key as NSData).bytes
        let dataPointer = (self as NSData).bytes
        let digestLength = Int(CC_SHA1_DIGEST_LENGTH)
        let hash = UnsafeMutablePointer<UInt8>.allocate(capacity: digestLength)
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), keyPointer, key.count, dataPointer, self.count, hash)
        return Data(bytes: hash, count: digestLength).hexEncodedString()
    }
    
    private func hexEncodedString() -> String {
        let format = "%02hhx"
        return self.map { String(format: format, $0) }.joined()
    }
}
