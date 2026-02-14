// Created by Ziad Al-Fakharany

import SwiftUI

struct MemeTrendingSection: View {
    let title: String
    let memes: [MemeUIModel]
    let onMemeTap: (MemeUIModel) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundStyle(.white)
                .padding(.horizontal, 16)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(memes) { meme in
                    TrendingMemeCard(meme: meme)
                        .onTapGesture { onMemeTap(meme) }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

private struct TrendingMemeCard: View {
    let meme: MemeUIModel

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            AsyncImage(url: meme.imageURL) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.05))
                        ProgressView().tint(.white)
                    }
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                case .failure:
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.05))
                        Image(systemName: "photo")
                            .font(.system(size: 24))
                            .foregroundStyle(.white.opacity(0.3))
                    }
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 140)
            .clipped()

            Text(meme.name)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .lineLimit(1)
        }
    }
}
