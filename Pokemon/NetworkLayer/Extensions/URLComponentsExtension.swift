//
//  URLComponentst
//  Pokemon
//
//  Created by Dimil T Mohan on 2021/07/10.
//

import Foundation

extension URLComponents {
    
    init?(service: NetworkServiceProtocol) {
        guard let url = service.baseURL?.appendingPathComponent(service.path) else { return nil }
        self.init(url: url, resolvingAgainstBaseURL: false)!
        
        guard case let .requestParameters(parameters) = service.task, service.parametersEncoding == .url else { return }
        
        queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: String(describing: value))
        }
    }
}
