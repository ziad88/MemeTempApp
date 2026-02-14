// Created by Ziad Al-Fakharany

import Foundation

struct BaseResponse<T: Codable>: Codable {
    let data: T
    let success: Bool
}
