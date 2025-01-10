//
//  EmojiMemoryGame.swift
//  MemorizeProject
//
//  Created by Alfredo Perry on 8/30/24.
//

import SwiftUI


class EmojiMemoryGame: ObservableObject{
    private static let themes = [
        CardTheme(name: "Halloween", color: .orange, emojis: ["👻", "🎃", "👹", "💀","🍭","😈","🧙‍♀️","🕷️","🕸️","☠️","🫣","😱"]),
        CardTheme(name: "Christmas", color: .teal, emojis: ["🥶","⛸️","☃️","❄️","🛷","🧤","🎄","🎅","🏂","🧦","🧣","🎿"]),
        CardTheme(name: "Sports", color: .yellow, emojis: ["🥇","⚾️","⚽️","🏀","🏈","🏋️","🏄","🧗","🎾","⛷️","🧗","🏌️‍♂️"]),
        CardTheme(name: "Green", color: .green, emojis: ["💚","🫛","🐲","🍀","🍏","🧩","🎍","🫑","🩲","🦎","🍐","🍵"]),
        CardTheme(name: "Transportation", color: .red, emojis: ["🚀","🚗","⛵️","🚒","🚢","🚁","🏎️","🚠","🚂","🚚","🛳️","🚑"]),
        CardTheme(name: "Blue", color: .blue, emojis: ["🌊","💧","🦕","🖌️","🥏","🐬","🧵","🦋","🪁","🪣","🩵","🌀"])
    ]
    
    @Published private var model = EmojiMemoryGame.createMemoryGame()
    
    private static var randomTheme: CardTheme?

    private static func createMemoryGame() -> MemoryGame<String>{
        
        randomTheme = themes.randomElement()!
        //var emojiSet = randomTheme.emojis
        
        return MemoryGame(numberOfPairsOfCards: 12){ pairIndex in
            if randomTheme!.emojis.indices.contains(pairIndex) {
                return randomTheme!.emojis[pairIndex]
            }
            else{
                return "❌"
            }
        }
    }
            
    var cards: Array<MemoryGame<String>.Card>{
        return model.cards
    }
    
    //MARK: - Intents
    
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: MemoryGame<String>.Card){
        model.choose(card)
    }
    
    func newGame(){
        model = EmojiMemoryGame.createMemoryGame()
    }
    
    func getTheme() -> CardTheme{
        return EmojiMemoryGame.randomTheme!
    }
    
    var score: Int {
        model.score
    }
}
