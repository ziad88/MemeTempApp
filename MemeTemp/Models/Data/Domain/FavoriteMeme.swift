// Created by Ziad Al-Fakharany

import Foundation

struct FavoriteMeme: Codable, Identifiable {
    let id: String
    let name: String
    let url: String
    let savedDate: Date

    init(from meme: Meme) {
        self.id = meme.id
        self.name = meme.name
        self.url = meme.url
        self.savedDate = Date()
    }

    init(from uiModel: MemeUIModel) {
        self.id = uiModel.id
        self.name = uiModel.name
        self.url = uiModel.imageURL?.absoluteString ?? ""
        self.savedDate = Date()
    }
}
