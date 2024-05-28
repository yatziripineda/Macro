//
//  TopicModel.swift
//  Macro
//
//  Created by yatziri on 27/05/24.
//

import Foundation
import SwiftData
import Observation

@Model
class Topics: Identifiable{
    var label: String
    var iconName: String
        
    init(label: String, iconName: String) {
        self.label = label
        self.iconName = iconName
    }
}
//
//
//class SelectedTopic: ObservableObject {
//    @Published var topic:Topics = Topics(label: "All Diagrams", iconName: "tray.fill")
//}
