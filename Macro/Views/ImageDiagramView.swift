//
//  ImageDiagramView.swift + ImageReviewView.swift
//  Macro
//
//  Created by yatziri on 14/05/24.
//  Created by Vitor Kalil on 21/05/24.
//

import SwiftUI

/// This is the view showed when you open an specific diagram from the list in the main View.
struct ImageDiagramView: View {
    @GestureState private var dragState = CGSize.zero
    @State private var currentIndex: Int = 0
    @State private var offset = CGSize.zero
    @State var diagram: Diagram?

    //Adding this one to manage visibility of the overlay
    @State var overlayVisibility:Bool = true
    
    //Brought from ImageReviewView
    @State private var recognizedData: [(String, CGRect)] = []
    @State private var image: UIImage?
    @State private var showCamera = false
    @State private var showWordReview:Bool = false
    
    @Environment(\.modelContext) var context
    
    var body: some View {
        if receivedInfoType() != "empty"{
            NavigationStack {
                if UIDevice.current.userInterfaceIdiom == .phone {
                    iPhoneVerticalView()
                        .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                overlayVisibility.toggle()
                            }) {
                                Image(systemName: "eye.slash.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                showWordReview.toggle()
                            } label: {
                                Image(systemName: "pencil.line")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .sheet(isPresented: $showWordReview, content: {
                            WordReviewView(rectangles: $recognizedData, image: $image, diagram: $diagram,showWordReviewView: $showWordReview)}
                    )
                } else {
                    iPadView()
                        .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                overlayVisibility.toggle()
                            }) {
                                Image(systemName: "eye.slash.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                showWordReview.toggle()
                            } label: {
                                Image(systemName: "pencil.line")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                
            }
        } else{ CameraView(image: $image, isShown: $showCamera, recognizedData: $recognizedData)}
    }
    /// returns what kind of data is received (Full diagram, Not yet saved Diagram or nothing (needs to take picture). It returns the format in one of the following Strings: "diagram", "preDiagram" and "empty"
    func receivedInfoType() -> String {
        return self.diagram != nil ? "diagram" : (self.image != nil && !self.recognizedData.isEmpty) ? "preDiagram" : "empty"
    }
    
    
    func iPhoneVerticalView() -> some View{
        VStack{
            ProgressView(value: 0.70)
                .tint(.primaryColor1)
                .padding()
                .scaleEffect(x: 1, y: 1)
                .cornerRadius(4.0)
                .frame(width: 600)
            
            GeometryReader { geo in
                Group {
                    if receivedInfoType() == "diagram" {
                        ZoomView {
                            DiagramOverlayedView(uiImage: UIImage(data: diagram!.image!)!, labels: diagram!.labels, currentIndex: $currentIndex, overlayVisibility: $overlayVisibility)
//                            ZStack {
//                                Image(uiImage: UIImage(data: diagram!.image!)!)
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                if overlayVisibility{
//                                    RectanglesOverlay(labels: diagram!.labels, currentIndex: $currentIndex)
//                                }
//                            }
                        }
                    } else if receivedInfoType() == "preDiagram"{
                        ZoomView {
                            DiagramOverlayedView(uiImage: image!, labels: tuppleToDiagramLabel(rectangles: recognizedData), currentIndex: $currentIndex, overlayVisibility: $overlayVisibility)
//                            ZStack {
//                                Text("preDiagram")
//                                Image(uiImage: image!)
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                if overlayVisibility{
//                                    RectanglesOverlay(labels: tuppleToDiagramLabel(rectangles: recognizedData), currentIndex: $currentIndex)
//                                }
//                            }
                        }
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 50)
            if receivedInfoType() == "diagram"{
                NavigationLink {
                    QuizzView(diagram: diagram!, currentIndex: $currentIndex)
                } label: {
                    Text("Start Quizz")
                }.padding()
                    .background(.primaryColor1)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .buttonStyle(PlainButtonStyle())
            } else if receivedInfoType() == "preDiagram"{
                Button(
                    action: {
                        let newDiagram:Diagram = Diagram(name:"", date: Date.now,labels:tuppleToDiagramLabel(rectangles: recognizedData), image: image?.pngData(), score: [], QuizDificulty: .easy, topic: [])
                        context.insert(newDiagram)
                        diagram = newDiagram
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
    
    /// IPad view for the Image Diagram
    func iPadView() -> some View{
        HStack{
            //            ProgressView(value: 0.70)
            //                .tint(.orange)
            //                .padding()
            //                .scaleEffect(x: 1, y: 10)
            //                .cornerRadius(4.0)
            //                .frame(width: 600)
                VStack{
                    GeometryReader { geo in
                        Group {
                            if receivedInfoType() == "diagram" {
                                ZoomView {
                                    DiagramOverlayedView(uiImage: UIImage(data: diagram!.image!)!, labels: diagram!.labels, currentIndex: $currentIndex, overlayVisibility: $overlayVisibility)
//                                    ZStack {
//                                        Image(uiImage: UIImage(data: diagram!.image!)!)
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                        if overlayVisibility{
//                                            RectanglesOverlay(labels: diagram!.labels, currentIndex: $currentIndex)}
//                                    }
                                }
                            } else if receivedInfoType() == "preDiagram"{
                                ZoomView {
                                    DiagramOverlayedView(uiImage: image!, labels: tuppleToDiagramLabel(rectangles: recognizedData), currentIndex: $currentIndex, overlayVisibility: $overlayVisibility)
//                                    ZStack {
//                                        Text("preDiagram")
//                                        Image(uiImage: image!)
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                        if overlayVisibility{
//                                            RectanglesOverlay(labels: tuppleToDiagramLabel(rectangles: recognizedData), currentIndex: $currentIndex)}
//                                    }
                                }
                            }
                        }
                        .frame(width: geo.size.width, height: geo.size.height)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 50)
                    if receivedInfoType() == "diagram" && !showWordReview{
                        NavigationLink {
                            QuizzView(diagram: diagram!, currentIndex: $currentIndex)
                        } label: {
                            Text("Start Quizz")
                        }.padding()
                            .background(.primaryColor1)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .buttonStyle(PlainButtonStyle())
                    }
            }
            if showWordReview{
                WordReviewView(rectangles: $recognizedData, image: $image, diagram: $diagram,showWordReviewView: $showWordReview)
                    .frame(width:470)
                    .background(Color(uiColor: .systemGray6))
            }

            
        }.onDisappear{if receivedInfoType() == "preDiagram"{
            let newDiagram:Diagram = Diagram(name:"", date: Date.now,labels:tuppleToDiagramLabel(rectangles: recognizedData), image: image?.pngData(), score: [], QuizDificulty: .easy, topic: [])
            context.insert(newDiagram)
            diagram = newDiagram
            }
        }
    }
}

//context.insert(Diagram(name:"", date: Date.now,labels:tuppleToDiagramLabel(rectangles: recognizedData), image: image?.pngData(), score: [], QuizDificulty: .easy))
