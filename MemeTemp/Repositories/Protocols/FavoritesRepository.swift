// Created by Ziad Al-Fakharany

import Foundation

protocol FavoritesRepository {
    func getFavorites() async -> [FavoriteMeme]
    func addFavorite(_ meme: FavoriteMeme) async
    func removeFavorite(id: String) async
    func isFavorite(id: String) async -> Bool
}
