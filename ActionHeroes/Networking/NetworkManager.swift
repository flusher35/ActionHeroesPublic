//
//  NetworkManager.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 18/01/2021.
//

import Alamofire
import Combine
import CryptoKit

class NetworkManager {

    typealias Parameters = [String: String]

    // MARK: - Private stored properties
    private let apiSettings: APISettingsProvider

    // MARK: - Internal methods
    init(apiSettings: APISettingsProvider = APISettings()) {
        self.apiSettings = apiSettings
    }

    // MARK: - Private methods
    private var currentTimeStamp: String {
        return String(Date().timeIntervalSince1970)
    }

    private var defaultAPIParameters: Parameters {
        let timeStamp = currentTimeStamp
        let hash = makeMD5(string: timeStamp + apiSettings.privateKey + apiSettings.publicKey)
        return [RequestParameter.timeStamp: timeStamp,
                RequestParameter.apiKey: apiSettings.publicKey,
                RequestParameter.hash: hash]
    }

    private func makeMD5(string: String) -> String {
        return Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
            .map { String(format: "%02hhx", $0) }
            .joined()
    }

    func request<DecodableType: Decodable>(_ urlString: String,
                                           method: HTTPMethod,
                                           parameters: Parameters = [:],
                                           encoder: ParameterEncoder? = nil,
                                           headers: HTTPHeaders? = nil) -> AnyPublisher<BaseMarvelResponse<DecodableType>, NetworkingError> {
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkingError.wrongURL).eraseToAnyPublisher()
        }
        return AF.request(url,
                          method: method,
                          parameters: parameters.merged(with: defaultAPIParameters),
                          encoder: encoder ?? URLEncodedFormParameterEncoder.default,
                          headers: headers ?? HTTPHeaders())
            .validate(statusCode: 200...201)
            .publishDecodable(type: BaseMarvelResponse<DecodableType>.self)
            .value()
            .mapError { NetworkingError.alamofire($0) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
