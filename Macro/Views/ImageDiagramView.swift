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
    
    @State var selectingTopic:Topics?
    //Adding this one to manage visibility of the overlay
    @State var overlayVisibility:Bool = true
    @State var topicPickerVisibility:Bool = false
    
    //Brought from ImageReviewView
    @State private var recognizedData: [(String, CGRect)] = []
    @State private var image: UIImage?
    @State private var showCamera = false
    @State private var showWordReview:Bool = false
    
    @Environment(\.modelContext) var context
    
    @State private var isQuiz: Bool = false
    
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
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    topicPickerVisibility.toggle()
                                }) {
                                    Image(systemName: "tag")
                                        .foregroundColor(Color.primaryColor1)
                                }
                            }
                        }
                        .sheet(isPresented: $showWordReview, content: {
                            if topicPickerVisibility{
                                
                                NavigationView(content: {
                                    TopicPickerView(selectedTopic: $selectingTopic)
                                        .navigationBarTitle("New Topic")
                                        .navigationBarTitleDisplayMode(.inline)
                                        .toolbar {
                                        
                                        ToolbarItem(placement: .confirmationAction) {
                                            Button("Done") {



                                            }
                                        }
                                        ToolbarItem(placement: .cancellationAction) {
                                            Button("Cancel") {
                                                

                                            }
                                        }
                                    }.toolbarBackground(Color(.white), for: .navigationBar)
                                        .toolbarBackground(.visible, for: .navigationBar)
                                })
                                
                                
                                
                            }else{
                                WordReviewView(rectangles: $recognizedData, image: $image, diagram: $diagram,showWordReviewView: $showWordReview,selectedTopic: $selectingTopic)
                            }
                        })
                } else {
                    iPadView()
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    overlayVisibility.toggle()
                                }) {
                                    Image(systemName: "eye.slash.fill")
                                        .foregroundColor(Color.primaryColor1)
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    showWordReview.toggle()
                                } label: {
                                    Image(systemName: "pencil.line")
                                        .foregroundColor(Color.primaryColor1)
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    topicPickerVisibility.toggle()
                                }) {
                                    Image(systemName: "tag")
                                        .foregroundColor(Color.primaryColor1)
                                }
                            }
                        }
                        .sheet(isPresented: $topicPickerVisibility, content: {
                            NavigationView(content: {
                                TopicPickerView(selectedTopic: $selectingTopic)
                                    .navigationBarTitle("Save to...")
                                    .navigationBarTitleDisplayMode(.inline)
                                    .toolbar {
                                    
                                    ToolbarItem(placement: .confirmationAction) {
                                        Button("+ List") {

                                        }
                                    }
                                    ToolbarItem(placement: .cancellationAction) {
                                        Button("Cancel") {
                                            topicPickerVisibility.toggle()
                                        }
                                    }
                                }.toolbarBackground(Color(.white), for: .navigationBar)
                                    .toolbarBackground(.visible, for: .navigationBar)
                            })
                        })
                }
            }
        } else{ CameraView(image: $image, isShown: $showCamera, recognizedData: $recognizedData)}
    }
    
    /// MARK: Function  "receivedInfoType()"
    /// returns what kind of data is received (Full diagram, Not yet saved Diagram or nothing (needs to take picture). It returns the format in one of the following Strings: "diagram", "preDiagram" and "empty"
    func receivedInfoType() -> String {
        return self.diagram != nil ? "diagram" : (self.image != nil && !self.recognizedData.isEmpty) ? "preDiagram" : "empty"
    }
    
    /// MARK: "iPhoneVerticalView()"
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
                    /* Primero mostramos la vista de un diagrama terminado */
                    if receivedInfoType() == "diagram" {
                        ZoomView {
                            DiagramOverlayedView(uiImage: UIImage(data: diagram!.image!)!, labels: diagram!.labels, currentIndex: $currentIndex, overlayVisibility: $overlayVisibility, isQuiz: $isQuiz)
                        }
                    } 
                    /* Después, mostramos la vista de un pre diagrama (antes de guardar) */
                    else if receivedInfoType() == "preDiagram"{
                        ZoomView {
                            DiagramOverlayedView(uiImage: image!, labels: tuppleToDiagramLabel(rectangles: recognizedData), currentIndex: $currentIndex, overlayVisibility: $overlayVisibility, isQuiz: $isQuiz)
                        }
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 50)
            
            /* Los botones que se muestran debajo del diagrama dependen del tipo de diagrama también */
            if receivedInfoType() == "diagram" {
                NavigationLink {
                    /* HERE: MainQuizView(diagram: diagram!, currentIndex: $currentIndex) */
                    
                    QuizzView(diagram: diagram!, currentIndex: $currentIndex)
                } label: {
                    Text("Start Quizz")
                }.padding()
                    .background(.primaryColor1)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .buttonStyle(PlainButtonStyle())
            } 
            // Si es un prediagrama el botón es para guardar.
            else if receivedInfoType() == "preDiagram"{
                Button(
                    action: {
                        let newDiagram:Diagram = Diagram(name:"", date: Date.now,labels:tuppleToDiagramLabel(rectangles: recognizedData), image: image?.pngData(), score: [], QuizDificulty: .easy, topic: selectingTopic )
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
            VStack{
                GeometryReader { geo in
                    Group {
                        // Si tenemos el diagrama completo usamos UIImage(data: diagram!.image!)!
                        if receivedInfoType() == "diagram" {
                            ZoomView {
                                DiagramOverlayedView(uiImage: UIImage(data: diagram!.image!)!, labels: diagram!.labels, currentIndex: $currentIndex, overlayVisibility: $overlayVisibility, isQuiz: $isQuiz)
                            }
                        } 
                        // Si apenas vamos a guardar el diagrama, usamos image!
                        else if receivedInfoType() == "preDiagram"{
                            ZoomView {
                                DiagramOverlayedView(uiImage: image!, labels: tuppleToDiagramLabel(rectangles: recognizedData), currentIndex: $currentIndex, overlayVisibility: $overlayVisibility, isQuiz: $isQuiz)
                            }
                        }
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 50)
                if receivedInfoType() == "diagram" && !showWordReview{
                    NavigationLink {
                        /* HERE MainQuizView(diagram: diagram!, currentIndex: $currentIndex) */
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
                WordReviewView(rectangles: $recognizedData, image: $image, diagram: $diagram,showWordReviewView: $showWordReview,selectedTopic: $selectingTopic)
                    .frame(width:470)
                    .background(Color(uiColor: .systemGray6))
            }
        }.onDisappear{if receivedInfoType() == "preDiagram"{
            let newDiagram:Diagram = Diagram(name:"", date: Date.now,labels:tuppleToDiagramLabel(rectangles: recognizedData), image: image?.pngData(), score: [], QuizDificulty: .easy, topic: selectingTopic)
            context.insert(newDiagram)
            diagram = newDiagram
        } else if (receivedInfoType() == "diagram" && selectingTopic != nil){diagram!.topic = selectingTopic}
        }
    }
}
