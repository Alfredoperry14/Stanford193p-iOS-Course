//
//  MemorizeProjectApp.swift
//  MemorizeProject
//
//  Created by Alfredo Perry on 8/29/24.
//

import SwiftUI

@main
struct MemorizeProjectApp: App {
    @StateObject var themeStore = ThemeStore(named: "Default")
    
    
    var body: some Scene {
        WindowGroup {
            GameThemeList(store: themeStore)
        }
    }
}
