//
//  PokemonItem.swift
//  Pokemon
//
//  Created by Dimil T Mohan on 2021/07/10.
//

import Foundation

struct PokemonItem: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeWrapper(key: .name, defaultValue: "")
        self.url = try container.decodeWrapper(key: .url, defaultValue: nil)
    }
    
    let name: String!
    let url: String?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case url
    }
}
