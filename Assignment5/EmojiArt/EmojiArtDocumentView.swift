//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Alfredo Perry on 10/5/24.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    typealias Emoji = EmojiArt.Emoji
    
    @ObservedObject var document: EmojiArtDocument
    
    private let paletteEmojiSize: CGFloat = 40

    var body: some View {
        VStack(spacing: 0) {
            documentBody
            PaletteChooser()
                .font(.system(size: paletteEmojiSize))
                .padding(.horizontal)
                .scrollIndicators(.hidden)
        }
    }
    
    private var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                documentContents(in: geometry)
                    .scaleEffect(zoom * gestureZoom)
                    .offset(pan + gesturePan)
            }
            .gesture(TapGesture().onEnded { selectedEmojis.removeAll(keepingCapacity: false)})
            .gesture(panGesture.simultaneously(with: zoomGesture))
            .dropDestination(for: Sturldata.self) { sturldatas, location in
                return drop(sturldatas, at: location, in: geometry)
            }
        }
    }
    
    var selectedFont: Font = Font.system(size: CGFloat(11))
    
    @ViewBuilder
    private func documentContents(in geometry: GeometryProxy) -> some View {
        AsyncImage(url: document.background)
            .position(Emoji.Position.zero.in(geometry))
        ForEach(document.emojis) { emoji in
            Text(emoji.string)
                .font(selectedEmojis.contains(emoji.id) ? selectedFont : emoji.font)
                .position(emoji.position.in(geometry))
                .background(
                    selectedEmojis.contains(emoji.id) ? Color.blue.opacity(0.3) : Color.clear
                )
                .gesture(TapGesture(count: 1).onEnded { selectEmoji(emoji)})
        }
    }

    @State private var zoom: CGFloat = 1
    @State private var pan: CGOffset = .zero
    @State private var tapped = false
    @State private var selectedEmojis: Set<Emoji.ID> = []

    
    @GestureState private var gestureZoom: CGFloat = 1
    @GestureState private var gesturePan: CGOffset = .zero
    @GestureState private var selectGesture: Bool = false
    
    private func selectEmoji(_ emoji: Emoji) {
        if selectedEmojis.contains(emoji.id) {
            selectedEmojis.remove(emoji.id)
        } else {
            selectedEmojis.insert(emoji.id)
        }
    }
    
    
    private var zoomGesture: some Gesture {
        MagnificationGesture()
            .updating($gestureZoom) { inMotionPinchScale, gestureZoom, _ in
                gestureZoom = inMotionPinchScale
            }
            .onEnded { endingPinchScale in
                zoom *= endingPinchScale
            }
    }
    
    private var panGesture: some Gesture {
        DragGesture()
            .updating($gesturePan) { inMotionDragGestureValue, gesturePan, _ in
                gesturePan = inMotionDragGestureValue.translation
            }
            .onEnded { endingDragGestureValue in
                pan += endingDragGestureValue.translation
            }
    }
    
    private func drop(_ sturldatas: [Sturldata], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        for sturldata in sturldatas {
            switch sturldata {
            case .url(let url):
                document.setBackground(url)
                return true
            case .string(let emoji):
                let dropPos = emojiPosition(at: location, in: geometry)
                
                document.addEmoji(
                    emoji,
                    at: dropPos,
                    size: paletteEmojiSize / zoom
                )
                print("Dropping emoji at position: \(location)") // Debugging the drop position
                return true
            default:
                break
            }
        }
        return false
    }
    
    private func emojiPosition(at location: CGPoint, in geometry: GeometryProxy) -> Emoji.Position {
        let center = geometry.frame(in: .local).center
        return Emoji.Position(
            x: Int((location.x - center.x - pan.width) / zoom),
            y: Int(-(location.y - center.y - pan.height) / zoom)
        )
    }
}

#Preview {
    EmojiArtDocumentView(document: EmojiArtDocument())
        .environmentObject(PaletteStore(named: "Preview"))
}
