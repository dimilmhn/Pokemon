//
//  URLRequest
//  Pokemon
//
//  Created by Dimil T Mohan on 2021/07/10.
//

import Foundation

extension URLRequest {
    
    init?(service: NetworkServiceProtocol) {
        guard let urlComponents = URLComponents(service: service) else { return nil }
        self.init(url: urlComponents.url!)
        httpMethod = service.method.rawValue
        service.headers?.forEach { key, value in
            addValue(value, forHTTPHeaderField: key)
        }
        
        guard case let .requestParameters(parameters) = service.task, service.parametersEncoding == .json else { return }
        httpBody = try? JSONSerialization.data(withJSONObject: parameters)
    }
}
