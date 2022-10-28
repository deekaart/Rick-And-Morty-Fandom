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
    public let status: Status?
    public let species: String?
    public let type: String?
    public let gender: Gender?
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

public enum Status: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}

public enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
}

public enum CharacterFilter: String, CaseIterable {
    case name, status, species, gender
}
