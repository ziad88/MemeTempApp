// Created by Ziad Al-Fakharany

import Foundation

struct MemeUIModel: Identifiable, Equatable {
    let id: String
    let name: String
    let imageURL: URL?

    init(from meme: Meme) {
        self.id = meme.id
        self.name = meme.name
        self.imageURL = URL(string: meme.url)
    }

    init(from favorite: FavoriteMeme) {
        self.id = favorite.id
        self.name = favorite.name
        self.imageURL = URL(string: favorite.url)
    }
}
