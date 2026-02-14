// Created by Ziad Al-Fakharany

import SwiftUI

struct MemeCard: View {
    let meme: MemeUIModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: meme.imageURL) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(0.05))
                        ProgressView()
                            .tint(.white)
                    }
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 353, height: 260)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                case .failure:
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(0.05))
                        Image(systemName: "photo")
                            .font(.system(size: 36))
                            .foregroundStyle(.white.opacity(0.3))
                    }
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 353, height: 260)

            Text(meme.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .lineLimit(1)
                .padding(.horizontal, 4)
        }
    }
}
