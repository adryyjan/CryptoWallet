//
//  NetworkingMenager.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 25/08/2025.
//

import Foundation
import Combine

final class NetworkingMenager {
    static let shared = NetworkingMenager()
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url):
                return "No data available \(url)"
            case .unknown:
                return "Decoding failed"
            }
        }
    }
    
    private init() {}
    
    func download(with url: URL) -> AnyPublisher<Data,Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
//            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap({try self.handleURLResponse(output: $0, url: url)})
            .eraseToAnyPublisher()
    }
    
    func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data{
        guard let resposnse = output.response as? HTTPURLResponse, resposnse.statusCode >= 200 && resposnse.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }
    
    func handleComplition(complition: Subscribers.Completion<any Publishers.Decode<AnyPublisher<Data, any Error>, [CoinModel], JSONDecoder>.Failure>) {
        switch complition {
            case .failure(let error):
            print("Error: \(error)")
        case .finished:
            break
        }
    }
}
