//
//  Character.swift
//  RickAndMortyCharacters
//
//  Created by Murad on 27.10.22.
//

import Foundation

public struct Character: Codable, Identifiable {
    public let id: Int?
    public let name: String?
    public let status: String?
    public let species: String?
    public let type: String?
    public let gender: String?
    public let origin: Origin?
    public let image: String?
}

extension Character: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name!.hashValue)
    }

    public static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.name == rhs.name && lhs.type == rhs.type && lhs.gender == rhs.gender
    }
}

public enum Status: String {
    case alive
    case dead
    case unknown = "unknown"
    case none = ""
}

public enum Gender: String {
    case female
    case male
    case genderless
    case unknown = "unknown"
    case none = ""
}

public enum CharacterFilter: String, CaseIterable {
    case name, status, species, gender
}
