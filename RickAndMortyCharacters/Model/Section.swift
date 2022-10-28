//
//  Section.swift
//  RickAndMortyCharacters
//
//  Created by Murad on 28.10.22.
//

import Foundation

enum Section {
    case gender(String)
    case species(String)
    case type(String)
    case origin(String)

    var data: String {
        switch self {
        case .gender(let value):
            return value
        case .species(let value):
            return value
        case .type(let value):
            return value
        case .origin(let value):
            return value
        }
    }

    var count: Int {
        return 1
    }

    var title: String {
        switch self {
        case .gender:
            return "GENDER"
        case .species:
            return "SPECIES"
        case .type:
            return "TYPE"
        case .origin:
            return "ORIGIN"
        }
    }
}
