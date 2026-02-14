// Created by Ziad Al-Fakharany

@testable import MemeTemp
import Foundation

class MockMemeRepository: MemeRepository {
    var memesToReturn: [Meme] = []
    var errorToThrow: Error?

    func getMemes() async throws -> [Meme] {
        if let error = errorToThrow {
            throw error
        }
        return memesToReturn
    }
}
