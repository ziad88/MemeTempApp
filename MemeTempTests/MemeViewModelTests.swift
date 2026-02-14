// Created by Ziad Al-Fakharany

@testable import MemeTemp
import XCTest

@MainActor
final class MemeViewModelTests: XCTestCase {
    var viewModel: MemeViewModel!
    var mockRepository: MockMemeRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockMemeRepository()
        viewModel = MemeViewModel(repository: mockRepository)
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }

    func testFetchMemesSuccess() async {
        mockRepository.memesToReturn = [
            Meme(id: "1", name: "Drake", url: "https://example.com/drake.jpg"),
            Meme(id: "2", name: "Distracted Boyfriend", url: "https://example.com/boyfriend.jpg")
        ]

        await viewModel.fetchMemes()

        XCTAssertEqual(viewModel.state, .success)
        XCTAssertEqual(viewModel.memes.count, 2)
        XCTAssertEqual(viewModel.memes.first?.name, "Drake")
    }

    func testFetchMemesFailure() async {
        mockRepository.errorToThrow = APIError(error: .unknownApiError)

        await viewModel.fetchMemes()

        if case .failed = viewModel.state {
        } else {
            XCTFail("Expected .failed state")
        }
    }

    func testFetchMemesNoInternet() async {
        mockRepository.errorToThrow = APIError(error: .noInternetConnection)

        await viewModel.fetchMemes()

        XCTAssertEqual(viewModel.state, .noInternet)
    }

    func testFetchMemesEmptyResult() async {
        mockRepository.memesToReturn = []

        await viewModel.fetchMemes()

        XCTAssertEqual(viewModel.state, .empty)
        XCTAssertTrue(viewModel.memes.isEmpty)
    }

    func testPopularMemesContainsFirst10() async {
        mockRepository.memesToReturn = (1...25).map {
            Meme(id: "\($0)", name: "Meme \($0)", url: "https://example.com/\($0).jpg")
        }

        await viewModel.fetchMemes()

        XCTAssertEqual(viewModel.popularMemes.count, 10)
        XCTAssertEqual(viewModel.popularMemes.first?.id, "1")
    }

    func testTrendingMemesContainsNext10() async {
        mockRepository.memesToReturn = (1...25).map {
            Meme(id: "\($0)", name: "Meme \($0)", url: "https://example.com/\($0).jpg")
        }

        await viewModel.fetchMemes()

        XCTAssertEqual(viewModel.trendingMemes.count, 10)
        XCTAssertEqual(viewModel.trendingMemes.first?.id, "11")
    }

    func testRandomMemeReturnsValidElement() async {
        mockRepository.memesToReturn = [
            Meme(id: "1", name: "Drake", url: "https://example.com/drake.jpg")
        ]
        await viewModel.fetchMemes()

        let random = viewModel.randomMeme()

        XCTAssertNotNil(random)
        XCTAssertEqual(random?.name, "Drake")
    }

    func testRandomMemeReturnsNilWhenEmpty() async {
        mockRepository.memesToReturn = []
        await viewModel.fetchMemes()

        let random = viewModel.randomMeme()

        XCTAssertNil(random)
    }

    func testRefreshUpdatesState() async {
        mockRepository.memesToReturn = [
            Meme(id: "1", name: "Drake", url: "https://example.com/drake.jpg")
        ]

        await viewModel.refresh()

        XCTAssertFalse(viewModel.isRefreshing)
        XCTAssertEqual(viewModel.state, .success)
    }
}
