//
//  Theme.swift
//  MemorizeProject
//
//  Created by Alfredo Perry on 10/22/24.
//

import Foundation
import SwiftUI

struct Theme: Identifiable, Hashable, Codable{
    var name: String
    var color: RGBA
    var emojis: [String]
    var id = UUID()
    
    var pairsOfCards: Int {
        get {
            return emojis.count
        }
    }
    
    static var builtins: [Theme] {
            [
                Theme(name: "Halloween", color: RGBA(red: 1, green: 0.5, blue: 0, alpha: 1), emojis: ["👻", "🎃", "👹", "💀", "🍭", "😈", "🧙‍♀️", "🕷️", "🕸️", "☠️", "🫣", "😱"]),
                Theme(name: "Christmas", color: RGBA(red: 0, green: 1, blue: 0, alpha: 1), emojis: ["🥶", "⛸️", "☃️", "❄️", "🛷", "🧤", "🎄", "🎅", "🏂", "🧦", "🧣", "🎿"]),
                Theme(name: "Sports", color: RGBA(red: 0.2, green: 0.4, blue: 0.6, alpha: 1), emojis: ["🥇", "⚾️", "⚽️", "🏀", "🏈", "🏋️", "🏄", "🧗", "🎾", "⛷️", "🧗", "🏌️‍♂️"]),
                Theme(name: "Green", color: RGBA(red: 0, green: 1, blue: 0.5, alpha: 1), emojis: ["💚", "🫛", "🐲", "🍀", "🍏", "🧩", "🎍", "🫑", "🩲", "🦎", "🍐", "🍵"]),
                Theme(name: "Transportation", color: RGBA(red: 0.6, green: 0.6, blue: 1, alpha: 1), emojis: ["🚀", "🚗", "⛵️", "🚒", "🚢", "🚁", "🏎️", "🚠", "🚂", "🚚", "🛳️", "🚑"]),
                Theme(name: "Blue", color: RGBA(red: 0, green: 0, blue: 1, alpha: 1), emojis: ["🌊", "💧", "🦕", "🖌️", "🥏", "🐬", "🧵", "🦋", "🪁", "🪣", "🩵", "🌀"])
            ]
        }
}
