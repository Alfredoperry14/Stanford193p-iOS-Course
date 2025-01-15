//
//  MemorizeGame.swift
//  MemorizeProject
//
//  Created by Alfredo Perry on 8/30/24.
//

import Foundation
import SwiftUI

struct CardTheme{
    var name: String
    var color: Color
    var emojis: [String]
}

struct MemoryGame <CardContent> where CardContent: Equatable{
    private(set) var cards: Array <Card>
    private(set) var score: Int = 0
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent){
        cards = []
        //Add numberOfPairsOfCards x 2 cards
        for pairIndex in 0..<max(2,numberOfPairsOfCards){
            let content: CardContent = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id:"\(pairIndex + 1)a"))
            cards.append(Card(content: content, id: "\(pairIndex + 1)b"))
        }
        cards.shuffle()
    }
    
    var indexOfOneAndOnlyFaceUpCard: Int? {
        get {cards.indices.filter{index in cards[index].isFaceUp}.only}
        set {cards.indices.forEach{cards[$0].isFaceUp = (newValue == $0)}}
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id}) {
            
            if(!cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched){
                
                if let potentialMatchIndex = indexOfOneAndOnlyFaceUpCard{
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content{
                        cards[potentialMatchIndex].isMatched = true
                        cards[chosenIndex].isMatched = true
                        score += 2
                    }
                    else{
                        if(cards[chosenIndex].hasBeenSeen){
                            score -= 1
                        }
                        if(cards[potentialMatchIndex].hasBeenSeen){
                            score -= 1
                        }
                    }
                    if(!cards[chosenIndex].hasBeenSeen){
                        cards[chosenIndex].hasBeenSeen = true
                    }
                    if(!cards[potentialMatchIndex].hasBeenSeen){
                        cards[potentialMatchIndex].hasBeenSeen = true
                    }
                }
                else{
                    indexOfOneAndOnlyFaceUpCard = chosenIndex
                }
                cards[chosenIndex].isFaceUp = true
            }
        }
    }
    
    mutating func shuffle(){
        cards.shuffle()
        print(cards)
    }
    

    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var hasBeenSeen: Bool = false
        let content: CardContent
        
        var id: String
        
        var debugDescription: String {
            return "\(id): \(content) \(isFaceUp ? "up" : "down")\(isMatched ? "matched" : "" )"
        }
    }
}

extension Array{
    var only: Element?{
        return count == 1 ? first : nil
    }
    
}
