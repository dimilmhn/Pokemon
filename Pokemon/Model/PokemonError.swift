//
//  Error.swift
//  Pokemon
//
//  Created by Dimil T Mohan on 2021/07/12.
//

import Foundation

enum PokemonError: Error {
    case unknown
    case noData
    case network(NetworkError)
}
