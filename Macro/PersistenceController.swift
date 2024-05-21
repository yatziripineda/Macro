//
//  PersistenceController.swift
//  Macro
//
//  Created by yatziri on 21/05/24.
//
import Foundation
import SwiftData

class PersistenceController {
    static let shared = PersistenceController()

    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: Diagram.self, DiagramLabel.self)
        } catch {
            fatalError("Unresolved error \(error)")
        }
    }
}
