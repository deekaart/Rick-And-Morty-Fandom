//
//  Errors.swift
//  RickAndMortyCharacters
//
//  Created by Murad on 27.10.22.
//

import Foundation

public enum NetworkHelperError: Error {
    case InvalidURL
    case JSONDecodingError
    case RequestError(String)
    case UnknownError
}

public struct ResponseErrorMessage: Codable {
    let error: String
}
