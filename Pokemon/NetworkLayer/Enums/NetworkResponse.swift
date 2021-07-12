//
//  NetworkResponse.swift
//  Pokemon
//
//  Created by Dimil T Mohan on 2021/07/10.
//

enum NetworkResponse<T> {
    case success(T)
    case failure(NetworkError)
}
