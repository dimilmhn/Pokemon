//
//  NetworkServiceProvider.swift
//  Pokemon
//
//  Created by Dimil T Mohan on 2021/07/10.
//

import Foundation

final class NetworkServiceProvider {
    
    private var session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func request<T>(type: T.Type, service: NetworkServiceProtocol, completion: @escaping (NetworkResponse<T>) -> ()) where T: Decodable {
        guard let request = URLRequest(service: service) else {
            completion(.failure(.unknown))
            return
        }
        let task = self.session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            let httpResponse = response as? HTTPURLResponse
            self?.handleDataResponse(data: data, response: httpResponse, type: type, error: error, completion: completion)
        })
        task.resume()
    }
    
    private func handleDataResponse<T: Decodable>(data: Data?, response: HTTPURLResponse?, type: T.Type, error: Error?, completion: (NetworkResponse<T>) -> ()) {
        guard error == nil else { return completion(.failure(.unknown)) }
        guard let response = response else { return completion(.failure(.noJSONData)) }
        
        switch response.statusCode {
        case 200...299:
            guard let data = data, let model = try? JSONDecoder().decode(type, from: data) else { return completion(.failure(.unknown)) }
            completion(.success(model))
        default:
            completion(.failure(.unknown))
        }
    }
}
