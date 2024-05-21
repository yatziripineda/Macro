//
//  DiagramModel.swift
//  Macro
//
//  Created by yatziri on 14/05/24.
//

import Foundation
import SwiftData
import SwiftUI
enum DifficultyLevel: String, Codable {
    case easy, medium, hard
}

@Model
class Diagram: Identifiable {
    var name: String
    var date: Date?
    var image: Data?
    var score: [Float]
    var QuizDificulty: DifficultyLevel
    var labels: [DiagramLabel]

    init(name: String, date: Date?, labels: [DiagramLabel], image: Data?, score: [Float], QuizDificulty: DifficultyLevel) {
        self.name = name
        self.date = date
        self.labels = labels
        self.image = image
        self.score = score
        self.QuizDificulty = QuizDificulty
    }
}
//    HASHABE FUNCTIONS: Filter Functions
    
    //    func hash(into hasher: inout Hasher) {
    //        hasher.combine(id)
    //        hasher.combine(image)
    //        hasher.combine(label)
    //        hasher.combine(statistics)
    //    }
    //
    //    static func ==(lhs: DiagramInfo, rhs: DiagramInfo) -> Bool {
    //            return lhs.id == rhs.id &&
    //                lhs.image == rhs.image &&
    //                lhs.label == rhs.label &&
    //                lhs.statistics == rhs.statistics
    //        }

