//
//  ThemeStore.swift
//  MemorizeProject
//
//  Created by Alfredo Perry on 10/22/24.
//

import SwiftUI


extension UserDefaults {
    func themes(forKey key: String) -> [Theme] {
        if let jsonData = data(forKey: key), let decodedThemes = try? JSONDecoder().decode([Theme].self , from: jsonData) {
            return decodedThemes
        } else {
            return []
        }
    }
    
    func set(_ themes: [Theme], forKey key: String){
        let data = try? JSONEncoder().encode(themes)
        set(data, forKey: key)
    }
}



class ThemeStore: ObservableObject, Identifiable{
    let name: String
    var id: String { name }
    
    private var userDefaultsKey: String { "Theme: " + name}
    
    var themes: [Theme] {
        get {
            UserDefaults.standard.themes(forKey: userDefaultsKey)
        }
        set {
            if !newValue.isEmpty {
                UserDefaults.standard.set(newValue, forKey: userDefaultsKey)
                objectWillChange.send()
            }
        }
    }
    
    init(named name: String) {
        self.name = name
        if themes.isEmpty {
            themes = Theme.builtins
            if themes.isEmpty {
                themes = [Theme(name: "Default", color: RGBA(red: 100, green: 100, blue: 100, alpha: 100), emojis: [])]
            }
        }
    }
    
    func append(_ theme: Theme) { // at end of palettes
        if let index = themes.firstIndex(where: { $0.id == theme.id }) {
            if themes.count == 1 {
                themes = [theme]
            } else {
                themes.remove(at: index)
                themes.append(theme)
            }
        } else {
            themes.append(theme)
        }
    }
}


extension ThemeStore: Hashable {
    static func == (lhs: ThemeStore, rhs: ThemeStore) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
}
