//
//  NetworkServiceProtocol.swift
//  Pokemon
//
//  Created by Dimil T Mohan on 2021/07/10.
//

import Foundation

typealias Headers = [String: String]

protocol NetworkServiceProtocol {
    var baseURL: URL? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: Task { get }
    var headers: Headers? { get }
    var parametersEncoding: ParametersEncoding { get }
}
