//
//  Info.swift
//  RickAndMortyCharacters
//
//  Created by Murad on 27.10.22.
//

import Foundation

struct Info: Codable {
    let count: Int?
    let pages: Int?
    let next: String?
    let prev: String?
}

struct CharacterAPIRequestResponse: Codable {
    let info: Info
    let results: [Character]
}
