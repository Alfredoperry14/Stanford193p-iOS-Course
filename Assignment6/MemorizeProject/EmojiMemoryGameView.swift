//
//  ContentView.swift
//  MemorizeProject
//
//  Created by Alfredo Perry on 8/29/24.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack{
            let theme = viewModel.themeName
            Text("Memorize Theme")
                .font(.largeTitle)
                .bold()
            Text(theme)
                .font(.title)
                .bold()
                .foregroundStyle(viewModel.themeColor)
            ScrollView{
                cards
                    .animation(.default, value: viewModel.cards)
            }
            Text("Score: \(viewModel.score)")
                .font(.title)
            //Spacer()
                .bold()
        }
        .padding()

    }
    
    
    var cards: some View{
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 0)], spacing: 0){
            ForEach(viewModel.cards){ card in
                CardView(card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            }
        }
        .foregroundColor(viewModel.themeColor)
    }
    
}





#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: Theme.builtins[0]))
}
