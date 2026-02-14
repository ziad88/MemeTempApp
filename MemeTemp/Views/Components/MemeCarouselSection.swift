// Created by Ziad Al-Fakharany

import SwiftUI

struct MemeCarouselSection: View {
    let title: String
    let memes: [MemeUIModel]
    let onMemeTap: (MemeUIModel) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundStyle(.white)
                .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(memes) { meme in
                        MemeCard(meme: meme)
                            .onTapGesture { onMemeTap(meme) }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}
