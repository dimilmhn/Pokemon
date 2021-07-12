//
//  PokemonListService.swift
//  Pokemon
//
//  Created by Dimil T Mohan on 2021/07/10.
//

import Foundation

struct PokemonListService: NetworkServiceProtocol {
    init(_ urlString: String?) {
        self.urlString = urlString
    }
    
    var urlString: String?

    var baseURL: URL? {
        return URL(string: urlString ?? "https://pokeapi.co/api/v2/pokemon/")
    }
    
    var path: String {
        return ""
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var task: Task {
        .requestPlain
    }
    
    var headers: Headers? {
        return nil
    }
    
    var parametersEncoding: ParametersEncoding {
        return .json
    }
}
