//
//  DetailViewModel.swift
//  RickAndMortyCharacters
//
//  Created by Murad on 28.10.22.
//

import Foundation

class DetailViewModel {
    
    func getCharacterInfoList(character: Character) -> [Section] {
        return [.gender(character.gender ?? "Not Found"),
                .species(character.species ?? "Not Found"),
                .type(character.type ?? "Not Found"),
                .origin(character.origin?.name ?? "Not Found")]
    }
}
