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
    var topic: [Topics]
  
    
    init(name: String, date: Date?, labels: [DiagramLabel], image: Data?, score: [Float], QuizDificulty: DifficultyLevel, topic: [Topics]) {
        self.name = name
        self.date = date
        self.labels = labels
        self.image = image
        self.score = score
        self.QuizDificulty = QuizDificulty
        self.topic = topic
    }
}

