// Created by Ziad Al-Fakharany

import SwiftUI

enum ViewState: Equatable {
    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none),
             (.loading, .loading),
             (.empty, .empty),
             (.noInternet, .noInternet),
             (.success, .success):
            return true
        case (.failed(let lhsError), .failed(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }

    case none
    case loading
    case empty
    case noInternet
    case failed(Error)
    case success
}

class BaseViewModel: ObservableObject {
    @MainActor @Published var state: ViewState = .none

    @MainActor
    func setState(_ state: ViewState) {
        withAnimation(.easeInOut(duration: 0.3)) {
            self.state = state
        }
    }

    func onStart() { }
}
