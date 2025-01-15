//
//  ThemeEditor.swift
//  MemorizeProject
//
//  Created by Alfredo Perry on 10/23/24.
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: Theme
    @Environment(\.dismiss) private var dismiss  // Add this to enable dismissal
    
    @State private var emojisToAdd: String = ""
    @State private var numberOfPairs: Int  // Add this for pairs control
    
    private let emojiFont = Font.system(size: 40)
    
    // Initialize numberOfPairs with current emoji count
    init(theme: Binding<Theme>) {
        self._theme = theme
        self._numberOfPairs = State(initialValue: theme.wrappedValue.emojis.count)
    }

    enum Focused {
        case name
        case addEmojis
        case color
        case numberOfPairs
    }

    @FocusState private var focused: Focused?
    
    var body: some View {
        NavigationStack {
            Form {
                nameSection
                emojisSection
                colorSection
                pairsSection
            }
            .navigationTitle("Edit Theme")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    var nameSection: some View {
        Section(header: Text("Name")) {
            TextField("Name", text: $theme.name)
                .focused($focused, equals: .name)
        }
    }
    
    var emojisSection: some View {
        Section(header: Text("Add Emojis")) {
            TextField("Tap to add emoji", text: $emojisToAdd)
                .focused($focused, equals: .addEmojis)
                .font(emojiFont)
                .onChange(of: emojisToAdd) { oldValue, newValue in
                    // Filter for emoji characters
                    let filtered = newValue.filter { $0.isEmoji }
                    if filtered != newValue {
                        emojisToAdd = filtered
                    }
                    if !filtered.isEmpty {
                        // Add new emoji to theme
                        theme.emojis.append(filtered)
                        // Clear the input field
                        emojisToAdd = ""
                    }
                }
            removeEmojis
        }
    }
    
    var colorSection: some View {
        Section(header: Text("Theme Color")) {
            ColorPicker("Color", selection: Binding(
                get: { Color(rgba: theme.color) },
                set: { theme.color = RGBA(color: $0) }
            ))
            .focused($focused, equals: .color)
        }
    }
    
    var pairsSection: some View {
        Section(header: Text("Number of Pairs")) {
            Stepper("Pairs: \(numberOfPairs)", value: $numberOfPairs, in: 1...theme.emojis.count)
                .focused($focused, equals: .numberOfPairs)
        }
    }
    
    var removeEmojis: some View {
        VStack(alignment: .trailing) {
            Text("Tap to Remove Emojis")
                .font(.caption)
                .foregroundColor(.gray)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(theme.emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                if let index = theme.emojis.firstIndex(of: emoji) {
                                    theme.emojis.remove(at: index)
                                    // Ensure numberOfPairs doesn't exceed available emojis
                                    numberOfPairs = min(numberOfPairs, theme.emojis.count)
                                }
                            }
                        }
                        .font(emojiFont)
                }
            }
        }
    }
}


struct Preview: View {
    @State private var theme = Theme(
        name: "Preview Theme",
        color: RGBA(red: 1, green: 0, blue: 0, alpha: 1),  // Red color
        emojis: ["😀", "😃", "😄", "😁", "😆"]  // Some sample emojis
    )
    
    var body: some View {
        ThemeEditor(theme: $theme)
    }
}

#Preview {
    Preview()
}
