// Created by Ziad Al-Fakharany

import SwiftUI

class MemeViewModel: BaseViewModel {
    @MainActor @Published var memes: [MemeUIModel] = []
    @MainActor @Published var popularMemes: [MemeUIModel] = []
    @MainActor @Published var trendingMemes: [MemeUIModel] = []
    @MainActor @Published var isRefreshing = false

    private let repository: MemeRepository

    init(repository: MemeRepository = MemeRepositoryImpl()) {
        self.repository = repository
    }

    override func onStart() {
        Task { await fetchMemes() }
    }

    func fetchMemes() async {
        await setState(.loading)

        do {
            let result = try await repository.getMemes()
            let uiModels = result.map(MemeUIModel.init)

            await MainActor.run {
                self.memes = uiModels
                self.popularMemes = Array(uiModels.prefix(10))
                self.trendingMemes = Array(uiModels.dropFirst(10).prefix(10))
            }

            await setState(uiModels.isEmpty ? .empty : .success)
        } catch let error as APIError {
            if error.error == .noInternetConnection {
                await setState(.noInternet)
            } else {
                await setState(.failed(error))
            }
        } catch {
            await setState(.failed(error))
        }
    }

    func refresh() async {
        await MainActor.run { isRefreshing = true }
        await fetchMemes()
        await MainActor.run { isRefreshing = false }
    }

    @MainActor
    func randomMeme() -> MemeUIModel? {
        memes.randomElement()
    }
}
