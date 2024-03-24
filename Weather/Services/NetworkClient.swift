//
//  NetworkClient.swift
//  Weather
//
//  Created by Artem Krasnov on 24.03.2024.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

enum HTTPMethods: String {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
}

final class NetworkClient {

    func createURL(url: String, queryItems: [URLQueryItem]) -> URL {
        var urlComponents = URLComponents(string: url)
        urlComponents?.queryItems = queryItems

        guard let url = urlComponents?.url else {
            preconditionFailure("Unable to construct \(url)")
        }
        return url
    }

    func createRequest(url: URL, httpMethod: HTTPMethods) -> URLRequest {

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        return request
    }
}

extension URLSession {

    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletion: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(T.self, from: data)
                        fulfillCompletion(.success(json))
                    } catch {
                        fulfillCompletion(.failure(error))
                    }
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        })
        return task
    }
}
