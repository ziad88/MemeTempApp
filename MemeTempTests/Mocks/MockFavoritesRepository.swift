// Created by Ziad Al-Fakharany

@testable import MemeTemp
import Foundation

class MockFavoritesRepository: FavoritesRepository {
    var storedFavorites: [FavoriteMeme] = []

    func getFavorites() async -> [FavoriteMeme] {
        storedFavorites
    }

    func addFavorite(_ meme: FavoriteMeme) async {
        if !storedFavorites.contains(where: { $0.id == meme.id }) {
            storedFavorites.append(meme)
        }
    }

    func removeFavorite(id: String) async {
        storedFavorites.removeAll { $0.id == id }
    }

    func isFavorite(id: String) async -> Bool {
        storedFavorites.contains { $0.id == id }
    }
}
