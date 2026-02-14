// Created by Ziad Al-Fakharany

@testable import MemeTemp
import XCTest

final class MemeRepositoryTests: XCTestCase {
    private let validJSON = """
    {
        "success": true,
        "data": {
            "memes": [
                { "id": "1", "name": "Drake Hotline Bling", "url": "https://i.imgflip.com/30b1gx.jpg", "width": 1200, "height": 1200, "box_count": 2 },
                { "id": "2", "name": "Two Buttons", "url": "https://i.imgflip.com/1g8my4.jpg", "width": 600, "height": 908, "box_count": 3 }
            ]
        }
    }
    """.data(using: .utf8)!

    func testDecodeBaseResponseWithMemes() throws {
        let decoder = JSONDecoder()
        let response = try decoder.decode(BaseResponse<MemeResponse>.self, from: validJSON)

        XCTAssertTrue(response.success)
        XCTAssertEqual(response.data.memes.count, 2)
        XCTAssertEqual(response.data.memes[0].id, "1")
        XCTAssertEqual(response.data.memes[0].name, "Drake Hotline Bling")
        XCTAssertEqual(response.data.memes[1].name, "Two Buttons")
    }

    func testDecodeMemeHasCorrectProperties() throws {
        let decoder = JSONDecoder()
        let response = try decoder.decode(BaseResponse<MemeResponse>.self, from: validJSON)
        let meme = response.data.memes[0]

        XCTAssertEqual(meme.id, "1")
        XCTAssertEqual(meme.name, "Drake Hotline Bling")
        XCTAssertEqual(meme.url, "https://i.imgflip.com/30b1gx.jpg")
    }

    func testInvalidJSONThrowsDecodeError() {
        let invalidJSON = "{ invalid json }".data(using: .utf8)!
        let decoder = JSONDecoder()

        XCTAssertThrowsError(try decoder.decode(BaseResponse<MemeResponse>.self, from: invalidJSON))
    }

    func testMemeUIModelFromMeme() {
        let meme = Meme(id: "42", name: "Test Meme", url: "https://example.com/meme.jpg")
        let uiModel = MemeUIModel(from: meme)

        XCTAssertEqual(uiModel.id, "42")
        XCTAssertEqual(uiModel.name, "Test Meme")
        XCTAssertEqual(uiModel.imageURL?.absoluteString, "https://example.com/meme.jpg")
    }

    func testMemeUIModelWithInvalidURL() {
        let meme = Meme(id: "1", name: "Bad URL", url: "not a valid url %%%")
        let uiModel = MemeUIModel(from: meme)

        XCTAssertNil(uiModel.imageURL)
    }

    func testFavoriteMemeFromUIModel() {
        let meme = Meme(id: "5", name: "Fav Meme", url: "https://example.com/fav.jpg")
        let uiModel = MemeUIModel(from: meme)
        let favorite = FavoriteMeme(from: uiModel)

        XCTAssertEqual(favorite.id, "5")
        XCTAssertEqual(favorite.name, "Fav Meme")
        XCTAssertEqual(favorite.url, "https://example.com/fav.jpg")
    }
}
