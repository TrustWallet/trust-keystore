// Copyright © 2017 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

/// Keystore wallet definition.
public struct Keystore: Codable {
    /// Ethereum address, optional.
    public var address: String?

    /// Wallet UUID, optional.
    public var id: String?

    /// Key header with encrypted private key and crypto parameters.
    public var crypto: KeyHeader

    /// Keystore version, must be 3.
    public var version = 3

    /// Initializes a `Keystore` from a JSON wallet.
    public init(contentsOf url: URL) throws {
        let data = try Data(contentsOf: url)
        self = try JSONDecoder().decode(Keystore.self, from: data)
    }

    /// Initializes a `Keystore` with a crypto header.
    public init(header: KeyHeader) {
        self.crypto = header
    }
}

/// Encrypted private key and crypto parameters.
public struct KeyHeader: Codable {
    /// Encrypted data.
    public var cipherText: String

    /// Cipher algorithm.
    public var cipher: String = "aes-128-cbc"

    /// Cipher parameters.
    public var cipherParams: CipherParams

    /// Key derivation function, must be scrypt.
    public var kdf: String = "scrypt"

    /// Key derivation function parameters.
    public var kdfParams: ScryptParams

    /// Message authentication code.
    public var mac: String

    /// Initializes a `KeyHeader` with standard values.
    public init(cipherText: String, cipherParams: CipherParams, kdfParams: ScryptParams, mac: String) {
        self.cipherText = cipherText
        self.cipherParams = cipherParams
        self.kdfParams = kdfParams
        self.mac = mac
    }

    enum CodingKeys: String, CodingKey {
        case cipherText = "ciphertext"
        case cipher
        case cipherParams = "cipherparams"
        case kdf
        case kdfParams = "kdfparams"
        case mac
    }
}

// AES128 CBC parameters.
public struct CipherParams: Codable {
    public static let blockSize = 16
    public var iv: String

    /// Initializes `CipherParams` with a random `iv` for AES 128.
    public init() {
        var data = Data(repeating: 0, count: CipherParams.blockSize)
        let result = data.withUnsafeMutableBytes { p in
            SecRandomCopyBytes(kSecRandomDefault, CipherParams.blockSize, p)
        }
        precondition(result == errSecSuccess, "Failed to generate random number")
        iv = data.hexString
    }
}
