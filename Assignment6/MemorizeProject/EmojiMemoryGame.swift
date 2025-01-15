//
//  EmojiMemoryGame.swift
//  MemorizeProject
//
//  Created by Alfredo Perry on 8/30/24.
//

import SwiftUI


class EmojiMemoryGame: ObservableObject{
    @Published private var model: MemoryGame<String>
    private var theme: Theme
    
    init(theme: Theme) {
        self.theme = theme
        self.model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }

    private static func createMemoryGame(theme: Theme) -> MemoryGame<String>{
                
        return MemoryGame(numberOfPairsOfCards: theme.pairsOfCards){ pairIndex in
            if theme.emojis.indices.contains(pairIndex) {
                return theme.emojis[pairIndex]
            }
            else{
                return "❌"
            }
        }
    }
            
    var cards: Array<MemoryGame<String>.Card>{
        return model.cards
    }
    
    var themeName: String {
        theme.name
    }
    
    var themeColor: Color {
        Color(rgba: theme.color)
    }
        
    var testTheme: Theme {
        theme
    }
    
    //MARK: - Intents
    
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: MemoryGame<String>.Card){
        model.choose(card)
    }
    
    func newGame(){
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    var score: Int {
        model.score
    }
}
