// Created by Ziad Al-Fakharany

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let viewController = SFSafariViewController(url: url)
        viewController.preferredBarTintColor = .black
        viewController.preferredControlTintColor = .red
        return viewController
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
