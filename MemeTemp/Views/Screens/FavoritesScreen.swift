// Created by Ziad Al-Fakharany

import SwiftUI

struct FavoritesScreen: View {
    @StateObject private var viewModel = FavoritesViewModel()
    @State private var selectedMeme: MemeUIModel?

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()

                switch viewModel.state {
                case .loading, .none:
                    LoadingView()

                case .empty:
                    EmptyStateView(
                        title: "No Favorites Yet",
                        message: "Tap the heart on any meme to save it here."
                    )

                case .success:
                    favoritesList

                case .noInternet, .failed:
                    EmptyStateView(
                        title: "No Favorites Yet",
                        message: "Tap the heart on any meme to save it here."
                    )
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(item: $selectedMeme) { meme in
                if let url = meme.imageURL {
                    SafariView(url: url)
                        .ignoresSafeArea()
                }
            }
        }
        .task { viewModel.onStart() }
    }

    private var favoritesList: some View {
        List {
            ForEach(viewModel.favorites) { meme in
                FavoriteRowView(meme: meme)
                    .listRowBackground(Color.black)
                    .onTapGesture { selectedMeme = meme }
            }
            .onDelete { indexSet in
                Task {
                    for index in indexSet {
                        let meme = viewModel.favorites[index]
                        await viewModel.toggleFavorite(meme)
                    }
                }
            }
        }
        .listStyle(.plain)
        .background(Color.black)
        .scrollContentBackground(.hidden)
    }
}

private struct FavoriteRowView: View {
    let meme: MemeUIModel

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: meme.imageURL) { phase in
                switch phase {
                case .empty:
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.05))
                        .overlay(ProgressView().tint(.white))
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                case .failure:
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundStyle(.white.opacity(0.3))
                        )
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 60, height: 60)

            Text(meme.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.white)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.3))
        }
        .padding(.vertical, 4)
    }
}
