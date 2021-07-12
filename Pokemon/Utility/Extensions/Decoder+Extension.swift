//
//  Decoder+Extension.swift
//  Pokemon
//
//  Created by Dimil T Mohan on 2021/07/10.
//

import Foundation
extension KeyedDecodingContainer {
    func decodeWrapper<T>(key: K, defaultValue: T) throws -> T
        where T : Decodable {
        return try decodeIfPresent(T.self, forKey: key) ?? defaultValue
    }
}
