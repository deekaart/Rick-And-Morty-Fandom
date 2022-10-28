//
//  NetworkHelper.swift
//  RickAndMortyCharacters
//
//  Created by Murad on 27.10.22.
//

import Foundation

public struct NetworkHelper {
    let baseURL = "https://rickandmortyapi.com/api/"

    func makeAPIRequestBy(query: String) async throws -> Data {
        if let url = URL(string: self.baseURL+query) {
            print("REQUESTING: \(url)")
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                let error: ResponseErrorMessage = try decodeJSONData(data: data)
                throw NetworkHelperError.RequestError(error.error)
            }

            return data
        } else {
            throw(NetworkHelperError.InvalidURL)
        }
    }

    func makeAPIRequestBy(url: String) async throws -> Data {
        if let url = URL(string: url) {
            print("REQUESTING: \(url)")
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                let error: ResponseErrorMessage = try decodeJSONData(data: data)
                throw NetworkHelperError.RequestError(error.error)
            }

            return data
        } else {
            throw(NetworkHelperError.InvalidURL)
        }
    }

    func decodeJSONData<T: Codable>(data: Data) throws -> T {
        let decoder = JSONDecoder()

        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch(let error) {
            print(error.localizedDescription)
            throw(NetworkHelperError.JSONDecodingError)
        }
    }
}
