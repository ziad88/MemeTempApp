// Created by Ziad Al-Fakharany

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MemeListScreen()
                .tabItem {
                    Label("Memes", systemImage: "photo.on.rectangle")
                }

            FavoritesScreen()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
        }
        .tint(.red)
        .preferredColorScheme(.dark)
    }
}
