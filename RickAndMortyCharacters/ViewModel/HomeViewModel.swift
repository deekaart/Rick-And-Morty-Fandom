//
//  HomeViewModel.swift
//  RickAndMortyCharacters
//
//  Created by Murad on 27.10.22.
//

import Foundation
import Kingfisher

class HomeViewModel {
    private let nm: NetworkManager = NetworkManager()
    private let cache = KingfisherManager.shared.cache

    var charactersList: [Character] = []

    func fetchCharacters(pageNumber: Int, completion: @escaping (([Character]?, Error?) -> Void)) {
        Task {
            do {
                let data = try await self.nm.getCharactersByPage(number: pageNumber)
                completion(data, nil)
            } catch(let error) {
                completion(nil, error)
            }
        }
    }

    func fetchCharacters(by filterOption: CharacterFilter, value: String, pageNumber: Int, completion: @escaping (([Character]?, Error?) -> Void)) {
        Task {
            do {
                let data = try await self.nm.getCharactersBy(their: filterOption, value: value, pageNumber: pageNumber)
                completion(data, nil)
            } catch(let error) {
                completion(nil, error)
            }
        }
    }

    func cleanUpCache() {
        DispatchQueue.global(qos: .background).async {
            self.cache.clearMemoryCache()
            self.cache.clearDiskCache()
            self.cache.cleanExpiredDiskCache()
        }
    }
}
