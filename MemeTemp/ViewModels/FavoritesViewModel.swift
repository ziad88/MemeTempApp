// Created by Ziad Al-Fakharany

import SwiftUI

class FavoritesViewModel: BaseViewModel {
    @MainActor @Published var favorites: [MemeUIModel] = []

    private let repository: FavoritesRepository

    init(repository: FavoritesRepository = FavoritesRepositoryImpl()) {
        self.repository = repository
    }

    override func onStart() {
        Task { await loadFavorites() }
    }

    func loadFavorites() async {
        let result = await repository.getFavorites()
        let uiModels = result.map(MemeUIModel.init)

        await MainActor.run {
            self.favorites = uiModels
        }

        await setState(uiModels.isEmpty ? .empty : .success)
    }

    func toggleFavorite(_ meme: MemeUIModel) async {
        let alreadyFavorited = await repository.isFavorite(id: meme.id)

        if alreadyFavorited {
            await repository.removeFavorite(id: meme.id)
        } else {
            await repository.addFavorite(FavoriteMeme(from: meme))
        }

        await loadFavorites()
    }

    func isFavorite(id: String) async -> Bool {
        await repository.isFavorite(id: id)
    }
}
