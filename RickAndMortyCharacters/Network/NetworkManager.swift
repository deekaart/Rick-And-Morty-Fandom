//
//  NetworkManager.swift
//  RickAndMortyCharacters
//
//  Created by Murad on 27.10.22.
//

import Foundation

public struct NetworkManager {
    let helper: NetworkHelper = NetworkHelper()

    func getCharacterBy(id: Int) async throws -> Character {
        let data = try await self.helper.makeAPIRequestBy(query: "character/\(String(id))")
        let character: Character = try self.helper.decodeJSONData(data: data)
        return character
    }

    func getCharactersByPage(number: Int) async throws -> [Character] {
        let data = try await self.helper.makeAPIRequestBy(query: "character/?page=\(String(number))")
        let info: CharacterAPIRequestResponse = try self.helper.decodeJSONData(data: data)
        return info.results
    }

    func getCharactersBy(their filterOption: CharacterFilter, value: String, pageNumber: Int) async throws -> [Character] {
        let query = "character/?page=\(pageNumber)&\(filterOption.rawValue.lowercased())=\(value)"
        let characterData = try await self.helper.makeAPIRequestBy(query: query)
        let infoModel: CharacterAPIRequestResponse = try self.helper.decodeJSONData(data: characterData)
        return infoModel.results
    }
}
