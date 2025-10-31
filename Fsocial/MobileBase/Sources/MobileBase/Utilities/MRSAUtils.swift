//
//  RSAUtils.swift
// Example
//
//  Created by ChungTV on 26/10/2022.
//  Copyright © 2022 FTech AI. All rights reserved.
//

import Foundation

struct MRSAUtils {
    static func encrypt(string: String, publicKey: String?) -> String? {
        guard let publicKey = publicKey else { return nil }
        guard let seckey = secKeyCreate(with: publicKey) else {
            return nil
        }
        return encrypt(string: string, publicKey: seckey)
    }
    
    private static func secKeyCreate(with publicKey: String) -> SecKey? {
        guard let data = Data(base64Encoded: publicKey) else { return nil }
        
        var attributes: CFDictionary {
            return [kSecAttrKeyType         : kSecAttrKeyTypeRSA,
                    kSecAttrKeyClass        : kSecAttrKeyClassPublic,
                    kSecAttrKeySizeInBits   : 2048,
                    kSecReturnPersistentRef : true] as CFDictionary
        }
        
        var error: Unmanaged<CFError>? = nil
        guard let secKey = SecKeyCreateWithData(data as CFData, attributes, &error) else {
            print(error.debugDescription)
            return nil
        }
        return secKey
    }
    
    private static func encrypt(string: String, publicKey: SecKey) -> String? {
        let buffer = [UInt8](string.utf8)
        
        var keySize   = SecKeyGetBlockSize(publicKey)
        var keyBuffer = [UInt8](repeating: 0, count: keySize)
        
        // Encrypto  should less than key length
        guard SecKeyEncrypt(publicKey, SecPadding.PKCS1, buffer, buffer.count, &keyBuffer, &keySize) == errSecSuccess else { return nil }
        return Data(bytes: keyBuffer, count: keySize).base64EncodedString()
    }
}
