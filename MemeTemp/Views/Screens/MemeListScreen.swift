// Created by Ziad Al-Fakharany

import SwiftUI

struct MemeListScreen: View {
    @StateObject private var viewModel = MemeViewModel()
    @StateObject private var favoritesViewModel = FavoritesViewModel()

    @State private var selectedMeme: MemeUIModel?
    @State private var showShareSheet = false
    @State private var shareURL: URL?

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()

                switch viewModel.state {
                case .loading, .none:
                    LoadingView()

                case .success:
                    successContent

                case .empty:
                    EmptyStateView(
                        title: "No Memes Found",
                        message: "Pull down to refresh and try again."
                    )

                case .noInternet:
                    ErrorStateView(
                        message: "No internet connection. Check your connection and try again."
                    ) {
                        Task { await viewModel.fetchMemes() }
                    }

                case .failed(let error):
                    ErrorStateView(message: error.localizedDescription) {
                        Task { await viewModel.fetchMemes() }
                    }
                }
            }
            .navigationTitle("MemeTempApp")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if let meme = viewModel.randomMeme(), let url = meme.imageURL {
                            shareURL = url
                            showShareSheet = true
                        }
                    } label: {
                        Image(systemName: "shuffle")
                            .foregroundStyle(.red)
                    }
                }
            }
            .refreshable {
                await viewModel.refresh()
            }
            .sheet(item: $selectedMeme) { meme in
                if let url = meme.imageURL {
                    SafariView(url: url)
                        .ignoresSafeArea()
                }
            }
            .sheet(isPresented: $showShareSheet) {
                if let url = shareURL {
                    ShareSheet(items: [url])
                }
            }
        }
        .task { viewModel.onStart() }
    }

    private var successContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                MemeCarouselSection(
                    title: "Most Popular Memes",
                    memes: viewModel.popularMemes
                ) { meme in
                    selectedMeme = meme
                }

                MemeTrendingSection(
                    title: "Trendy This Week",
                    memes: viewModel.trendingMemes
                ) { meme in
                    selectedMeme = meme
                }
            }
            .padding(.vertical, 16)
        }
        .background(Color.black)
    }
}
