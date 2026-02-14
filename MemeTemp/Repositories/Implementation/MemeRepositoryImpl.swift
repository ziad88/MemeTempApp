// Created by Ziad Al-Fakharany

import Foundation

class MemeRepositoryImpl: MemeRepository {
    func getMemes() async throws -> [Meme] {
        let result = try await APIClient.shared.request(
            request: GetMemesRequest(),
            model: BaseResponse<MemeResponse>.self
        )
        return result.data.memes
    }
}
