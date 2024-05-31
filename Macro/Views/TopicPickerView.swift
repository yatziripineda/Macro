//
//  TopicPickerView.swift
//  Macro
//
//  Created by yatziri on 29/05/24.
//

import SwiftUI
import SwiftData

struct TopicPickerView: View {
    @Query(sort: \Topics.label) private var topics: [Topics]
    @Binding var selectedTopic:Topics?
    @State var selectingTopic:Topics = Topics(label: "All Diagrams", iconName: "tray.fill")

    var body: some View {
        VStack {
            ForEach(topics, id: \.self) {topic in
                Button(topic.label){selectingTopic = topic}
            }
            Text("You selected: \(selectingTopic.label)")
            Button("SAVE"){
                if (selectingTopic.label == "All Diagrams"){
                    selectedTopic = nil
                }else{
                    selectedTopic = selectingTopic}
            }
        }
    }
}
