// Created by Ziad Al-Fakharany

import Foundation

actor FavoritesRepositoryImpl: FavoritesRepository {
    private let storageKey = "com.memetempapp.favorites"

    func getFavorites() async -> [FavoriteMeme] {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let favorites = try? JSONDecoder().decode([FavoriteMeme].self, from: data) else {
            return []
        }
        return favorites
    }

    func addFavorite(_ meme: FavoriteMeme) async {
        var favorites = await getFavorites()
        guard !favorites.contains(where: { $0.id == meme.id }) else { return }
        favorites.append(meme)
        save(favorites)
    }

    func removeFavorite(id: String) async {
        var favorites = await getFavorites()
        favorites.removeAll { $0.id == id }
        save(favorites)
    }

    func isFavorite(id: String) async -> Bool {
        let favorites = await getFavorites()
        return favorites.contains { $0.id == id }
    }

    private func save(_ favorites: [FavoriteMeme]) {
        guard let data = try? JSONEncoder().encode(favorites) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
