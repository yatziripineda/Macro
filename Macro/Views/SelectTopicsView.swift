//
//  SelectTopicsView.swift
//  Macro
//
//  Created by yatziri on 28/05/24.
//

import SwiftUI
import SwiftData
import SwiftUI

struct SelectTopicsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @Query(sort: \Topics.label) private var topics: [Topics]
    @State private var selectedTopics: Topics? = nil

    @Binding var diagram: Diagram?

    var body: some View {
        Text("Hola")
//        NavigationView {
//            Form {
//                Section(header: Text("Select Topics")) {
//                    ForEach(topics) { topic in
//                        MultipleSelectionRow(topic: topic, isSelected: selectedTopics.contains(where: { $0.id == topic.id })) {
//                            if let index = selectedTopics.firstIndex(where: { $0.id == topic.id }) {
//                                selectedTopics.remove(at: index)
//                            } else {
//                                selectedTopics.append(topic)
//                            }
//                        }
//                    }
//                }
//            }
//            .navigationBarTitle("Select Topics")
//            .navigationBarItems(trailing: Button("Save") {
//                if let diagram = diagram {
//                    diagram.topic = selectedTopics
//                    try? context.save()
//                }
//                dismiss()
//            })
//        }
    }
}

struct MultipleSelectionRow: View {
    var topic: Topics
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        HStack {
            Text(topic.label)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            self.action()
        }
    }
}


//#Preview {
//    SelectTopicsView()
//}
