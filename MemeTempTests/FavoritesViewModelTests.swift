// Created by Ziad Al-Fakharany

@testable import MemeTemp
import XCTest

@MainActor
final class FavoritesViewModelTests: XCTestCase {
    var viewModel: FavoritesViewModel!
    var mockRepository: MockFavoritesRepository!

    private let sampleMeme = MemeUIModel(from: Meme(id: "1", name: "Drake", url: "https://example.com/drake.jpg"))

    override func setUp() {
        super.setUp()
        mockRepository = MockFavoritesRepository()
        viewModel = FavoritesViewModel(repository: mockRepository)
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }

    func testLoadFavoritesEmpty() async {
        await viewModel.loadFavorites()

        XCTAssertEqual(viewModel.state, .empty)
        XCTAssertTrue(viewModel.favorites.isEmpty)
    }

    func testLoadFavoritesWithData() async {
        mockRepository.storedFavorites = [FavoriteMeme(from: sampleMeme)]

        await viewModel.loadFavorites()

        XCTAssertEqual(viewModel.state, .success)
        XCTAssertEqual(viewModel.favorites.count, 1)
        XCTAssertEqual(viewModel.favorites.first?.name, "Drake")
    }

    func testToggleFavoriteAddsMeme() async {
        await viewModel.toggleFavorite(sampleMeme)

        XCTAssertEqual(viewModel.favorites.count, 1)
        XCTAssertEqual(viewModel.favorites.first?.id, "1")
    }

    func testToggleFavoriteRemovesMeme() async {
        mockRepository.storedFavorites = [FavoriteMeme(from: sampleMeme)]

        await viewModel.toggleFavorite(sampleMeme)

        XCTAssertTrue(viewModel.favorites.isEmpty)
    }

    func testIsFavoriteReturnsTrueForSaved() async {
        mockRepository.storedFavorites = [FavoriteMeme(from: sampleMeme)]

        let result = await viewModel.isFavorite(id: "1")

        XCTAssertTrue(result)
    }

    func testIsFavoriteReturnsFalseForUnsaved() async {
        let result = await viewModel.isFavorite(id: "999")

        XCTAssertFalse(result)
    }
}
