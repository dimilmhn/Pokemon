//
//  PokemonList.swift
//  Pokemon
//
//  Created by Dimil T Mohan on 2021/07/10.
//

import Foundation

struct PokemonList: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try container.decodeWrapper(key: .count, defaultValue: nil)
        self.nextListURLString = try container.decodeWrapper(key: .nextListURLString, defaultValue: nil)
        self.previousListURLString = try container.decodeWrapper(key: .previousListURLString, defaultValue: nil)
        self.items = try container.decodeWrapper(key: .items, defaultValue: nil)
    }
    
    var count: Int?
    var nextListURLString: String?
    var previousListURLString: String?
    var items: [PokemonItem]?

    enum CodingKeys: String, CodingKey {
        case count
        case nextListURLString = "next"
        case previousListURLString = "previous"
        case items = "results"
    }
}
