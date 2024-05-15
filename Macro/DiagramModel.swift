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
class Diagram:Hashable {
    let id = UUID()
    var name:String = ""
    var date:Date?
    var labels:[DiagramLabel]
    init(name: String, date: Date?, labels: [DiagramLabel]) {
        self.name = name
        self.date = date
        self.labels = labels
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
}
