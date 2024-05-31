//
//  MacroApp.swift
//  Macro
//
//  Created by yatziri on 06/05/24.
//

import SwiftUI
import SwiftData
@main
struct MacroApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for:[Diagram.self,DiagramLabel.self,Topics.self]) // This is used to create Container of SwiftData
    }
}
