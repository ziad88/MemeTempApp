// Created by Ziad Al-Fakharany

import Foundation

protocol MemeRepository {
    func getMemes() async throws -> [Meme]
}
