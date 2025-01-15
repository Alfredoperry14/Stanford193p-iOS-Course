//
//  GameThemeList.swift
//  MemorizeProject
//
//  Created by Alfredo Perry on 10/22/24.
//

import SwiftUI

struct GameThemeList: View {
    @ObservedObject var store: ThemeStore
    @State private var editingTheme: Theme?
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(store.themes){ theme in
                    NavigationLink(destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: theme))) {
                        VStack(alignment: .leading){
                            Text(theme.name)
                                .font(.headline)
                            Text(theme.emojis.joined(separator: ","))
                            Text("# of Pairs in Game: \(theme.pairsOfCards)")
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true){
                        Button(role: .destructive){
                            store.themes.removeAll{$0.id == theme.id} // This triggers the sheet
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                                                    
                        Button {
                                editingTheme = theme // This triggers the sheet
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(Color(rgba: theme.color))
                    }
                }
            }
            .toolbar {
                Button {
                    store.append(Theme(
                        name: "New Theme",
                        color: RGBA(red: 0, green: 0, blue: 1, alpha: 1),
                        emojis: ["😀", "😃"]
                    ))
                    editingTheme = store.themes.last
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(item: $editingTheme) { theme in
                if let index = store.themes.firstIndex(where: { $0.id == theme.id }) {
                    ThemeEditor(theme: $store.themes[index])
                        .presentationDetents([.large])
                }
            }
        }
    }
}


#Preview {
    GameThemeList(store: ThemeStore(named: "Meow"))
        //.environmentObject(ThemeStore(named: "Meow"))
}

//I need to present a list of Games for the user to play
