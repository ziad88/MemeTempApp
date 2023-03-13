//
//  MemeResponse.swift
//  MemeTemp
//
//  Created by Ziad Alfakharany on 12/03/2023.
//

import Foundation

struct memeResponse: Codable {
    var data: meme
}

struct meme: Codable {
    var memes: [memeData]
}

struct memeData: Codable {
    var id: String
    var name: String
    var url: String
}
