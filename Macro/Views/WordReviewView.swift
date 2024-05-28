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
    @Query(sort: \Topics.label) private var topics: [Topics]
    @Binding var diagram:Diagram?
    @Binding var showWordReviewView:Bool
    
    init(rectangles: Binding<[(String, CGRect)]>,image:Binding<UIImage?>,diagram:Binding<Diagram?>,showWordReviewView:Binding<Bool>) {
        self._image = image
        self._rectangles = rectangles
        self._diagram = diagram
        self._showWordReviewView = showWordReviewView
        self._str = State(initialValue: rectangles.wrappedValue.isEmpty ? diagram.wrappedValue!.labels.map {$0.text} : rectangles.wrappedValue.map { $0.0 })
    }
    
    
    
    var body: some View {
        if rectangles.isEmpty { // Does one of the two views depending on what was received on the initialization
            VStack {
                ScrollView{
                    ForEach(0..<diagram!.labels.count, id: \.self) { index in
                        TextField("", text: $str[index])
                            .padding()
                            .clipShape(
                                RoundedRectangle(cornerRadius: 16)
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: 16)
                            )
                            .background(.secondaryColor1)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 16)
                            )
                            .padding()
                        
                    }
                }
                Button(
                    action: {
                        for i in 0..<diagram!.labels.count {
                            diagram!.labels[i].text = str[i]
                        }
                        UIDevice.current.userInterfaceIdiom == .phone ? dismiss() : showWordReviewView.toggle()
                    }) {
                        Text("Save")
                            .padding()
                            .foregroundColor(.white)
                            .background(.primaryColor1)
                            .cornerRadius(8)
                    }
                    .padding()
            }} else {
                VStack {
                    ScrollView{
                        ForEach(0..<rectangles.count, id: \.self) { index in
                            TextField("", text: $str[index])
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
                                .padding()
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
                                .background(.secondaryColor1)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
                                .padding()
                            
                        }
                    }
                    Button(
                        action: {
                            for i in 0..<rectangles.count {
                                rectangles[i] = (str[i], rectangles[i].1)
                            }
                            let tupleList:[DiagramLabel] = tuppleToDiagramLabel(rectangles: rectangles)
                            let data = image?.pngData()
                            context.insert(Diagram(name:"", date: Date.now,labels:tupleList, image: data, score: [], QuizDificulty: .easy, topic: []))
                            UIDevice.current.userInterfaceIdiom == .phone ? dismiss() : showWordReviewView.toggle()
                            
                        }) {
                            Text("Save")
                                .padding()
                                .foregroundColor(.white)
                                .background(.primaryColor1)
                                .cornerRadius(8)
                        }
                        .padding()
                }
            }
    }
}


