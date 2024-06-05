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
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTopic:Topics?
    @State var selectingTopic:Topics = Topics(label: "All Diagrams", iconName: "tray.fill")
    var allDiagrams = Topics(label: "All Diagrams", iconName: "tray.fill")
    var body: some View {
        VStack {
            List{
                Button{selectingTopic = allDiagrams} label: {
                    HStack{
                        Image(systemName: allDiagrams.iconName).foregroundColor(selectingTopic == allDiagrams ? .primaryColor1 : .gray)
                        Text(allDiagrams.label).foregroundColor(selectingTopic == allDiagrams ? .primaryColor1 : .gray)
                    }
                }
                ForEach(topics, id: \.self) {topic in
                    Button{selectingTopic = topic} label: {
                        HStack{
                            Image(systemName: topic.iconName).foregroundColor(selectingTopic == topic ? .primaryColor1 : .gray)
                            Text(topic.label).foregroundColor(selectingTopic == topic ? .primaryColor1 : .gray)
                        }
                    }
                }
            }
            Button{
                if (selectingTopic.label == "All Diagrams"){
                    selectedTopic = nil
                }else{
                    selectedTopic = selectingTopic}
                dismiss()
            } label: {
                Text("SAVE")
                    .padding()
                    .foregroundColor(.white)
                    .background(.primaryColor1)
                    .cornerRadius(8)
            }.padding()
            
        }.background(Color(uiColor: .systemGray6))
    }
}


