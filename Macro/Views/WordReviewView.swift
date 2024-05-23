//
//  WordReviewView.swift
//  Macro
//
//  Created by yatziri on 10/05/24.
//

import SwiftUI
import SwiftData

struct WordReviewView: View {
    
    @Environment(\.modelContext) var context
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss // added this var to dismiss the view latter
    @Binding var rectangles: [(String, CGRect)]
    @State var str: [String] = [""]
    
    
    init(rectangles: Binding<[(String, CGRect)]>,image:Binding<UIImage?>) {
        self._image = image
        self._rectangles = rectangles
        self._str = State(initialValue: rectangles.wrappedValue.map { $0.0 })
    }
    
    var body: some View {
        VStack {
            ScrollView{
                ForEach(0..<rectangles.count, id: \.self) { index in
                    TextField("", text: $str[index])
                        .padding()
                        .border(Color.gray)
                        .padding()
                }
            }
            Button(
                action: {
                    for i in 0..<rectangles.count {
                        rectangles[i] = (str[i], rectangles[i].1)
                    }
                    var tupleList:[DiagramLabel] = tuppleToDiagramLabel(rectangles: rectangles)
                    let data = image?.pngData()
                    context.insert(Diagram(name:"", date: Date.now,labels:tupleList, image: data, score: [], QuizDificulty: .easy))
                    dismiss()
                    
                }) {
                    Text("Save")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
        }
    }
}
