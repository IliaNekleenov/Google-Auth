//
//  AuthCodeProvider.swift
//  Google Auth
//
//  Created by NEKLEENOV Ilya on 15.09.2021.
//

import Foundation

let CODE_LIFE_SECONDS = 30

class AuthCodeGenerator {
    public func generateCode(for secret: String) -> String {
        guard let key = secret.base32Decoded else { return "------" }
        let keyData = Data(key)
        let currentTimeInterval = Int64(Date().timeIntervalSince1970) / Int64(CODE_LIFE_SECONDS)
        let data = Data(withUnsafeBytes(of: currentTimeInterval.bigEndian, Array.init))
        let hash = data.hmacSha1(key: keyData)
        return truncateHash(hash)
    }
    
    private func truncateHash(_ hash: String) -> String {
        let offset = Int(hash.suffix(1), radix: 16) ?? 0
        let offsetIndex = hash.index(hash.startIndex, offsetBy: offset * 2)
        let offsetEndIndex = hash.index(hash.startIndex, offsetBy: offset * 2 + 8)
        let resultString = hash[offsetIndex..<offsetEndIndex]
        print("res", resultString)
        let number = Int(resultString, radix: 16)! & 0x7FFFFFFF
        return String(String(number).suffix(6))
    }
}
