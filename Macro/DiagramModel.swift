//
//  DiagramModel.swift
//  Macro
//
//  Created by yatziri on 14/05/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Diagram {
    var name:String = ""
    var date:Date?
    var labels:[DiagramLabel]
    init(name: String, date: Date?, labels: [DiagramLabel]) {
        self.name = name
        self.date = date
        self.labels = labels
    }
}
