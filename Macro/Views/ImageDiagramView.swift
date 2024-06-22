//
//  ImageDiagramView.swift
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
    @State var overlayVisibility:Bool = true // Manage the visibility of the overlay
    @State var topicPickerVisibility:Bool = false
    @State private var recognizedData: [(String, CGRect)] = []
    @State private var image: UIImage?
    @State private var showCamera = false
    @State private var showWordReview:Bool = false
    @State private var isQuiz: Bool = false
    @State private var showAddNewTopic: Bool = false
    @State private var TopicName:String = ""
    @State private var selectedIcon: String = "figure"
    
    @Environment(\.modelContext) var context
    
    var body: some View {
        if receivedInfoType() != "empty"{
            NavigationStack {
                /* If the device is an iPhone... */
                if UIDevice.current.userInterfaceIdiom == .phone {
                    iPhoneVerticalView()
                        .toolbar {
                            /* Button to show or hide the overlayed rectangles */
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    overlayVisibility.toggle()
                                }) {
                                    Image(systemName: overlayVisibility ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(Color.primaryColor1)
                                }
                            }
                            /* Button to edit the labels */
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    showWordReview.toggle()
                                } label: {
                                    Image(systemName: "pencil.line")
                                        .foregroundColor(Color.primaryColor1)
                                }
                            }
                            /* Button to select the topic for the current diagram */
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    topicPickerVisibility.toggle()
                                }) {
                                    Image(systemName: "tag")
                                        .foregroundColor(Color.primaryColor1)
                                }
                            }
                        } // We show the modal for WordReview in the iPhone.
                        .sheet(isPresented: $topicPickerVisibility, content: {
                            NavigationView(content: {
                                TopicPickerView(selectedTopic: $selectingTopic)
                                    .navigationBarTitle("Save to...")
                                    .navigationBarTitleDisplayMode(.inline)
                                    .toolbar {
                                        ToolbarItem(placement: .confirmationAction) {
                                            Button("+ List") {
                                                showAddNewTopic.toggle()
                                            }.foregroundStyle(.primaryColor1)
                                        }
                                        ToolbarItem(placement: .cancellationAction) {
                                            Button("Cancel") {
                                                topicPickerVisibility.toggle()
                                            }.foregroundStyle(.primaryColor1)
                                        }
                                    }
                                    .toolbarBackground(.bar, for: .navigationBar)
                                    .toolbarBackground(.visible, for: .navigationBar)
                            }).sheet(isPresented: $showAddNewTopic, content: {
                                NavigationView(content: {
                                    AddNewTopicView(selectedIcon: $selectedIcon, TopicName: $TopicName)
                                        .navigationBarTitle("New Topic")
                                        .navigationBarTitleDisplayMode(.inline)
                                        .toolbar {
                                            ToolbarItem(placement: .confirmationAction) {
                                                Button("Done") {
                                                    context.insert(Topics(label: TopicName, iconName: selectedIcon))
                                                    self.showAddNewTopic.toggle()
                                                }.foregroundStyle(.primaryColor1)
                                            }
                                            ToolbarItem(placement: .cancellationAction) {
                                                Button("Cancel") {
                                                    self.showAddNewTopic.toggle()
                                                }.foregroundStyle(.primaryColor1)
                                            }
                                        }.toolbarBackground(.bar, for: .navigationBar)
                                        .toolbarBackground(.visible, for: .navigationBar)
                                })
                            })
                        }).sheet(isPresented: $showWordReview, content: {
                            WordReviewView(rectangles: $recognizedData, image: $image, diagram: $diagram,showWordReviewView: $showWordReview,selectedTopic: $selectingTopic)
                                .background(Color(uiColor: .systemGray6))
                        })
                } else {
                    /* If not, then is an iPad... */
                    iPadView()
                    // First we add all the buttons to the toolbar.
                        .toolbar {
                            /* Button to show or hide the overlayed rectangles */
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    overlayVisibility.toggle()
                                }) {
                                    Image(systemName: overlayVisibility ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(Color.primaryColor1)
                                }
                            }
                            /* Button to edit the labels */
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    showWordReview.toggle()
                                } label: {
                                    Image(systemName: "pencil.line")
                                        .foregroundColor(Color.primaryColor1)
                                }
                            }
                            /* Button to select the topic for the current diagram */
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    topicPickerVisibility.toggle()
                                }) {
                                    Image(systemName: "tag")
                                        .foregroundColor(Color.primaryColor1)
                                }
                            }
                        }
                    // Then, we add the modal to show the topic picker view.
                        .sheet(isPresented: $topicPickerVisibility, content: {
                            NavigationView(content: {
                                TopicPickerView(selectedTopic: $selectingTopic)
                                    .navigationBarTitle("Save to...")
                                    .navigationBarTitleDisplayMode(.inline)
                                    .toolbar {
                                        ToolbarItem(placement: .confirmationAction) {
                                            Button("+ List") {
                                                showAddNewTopic.toggle()
                                            }.foregroundStyle(.primaryColor1)
                                        }
                                        ToolbarItem(placement: .cancellationAction) {
                                            Button("Cancel") {
                                                topicPickerVisibility.toggle()
                                            }.foregroundStyle(.primaryColor1)
                                        }
                                    }
                                    .toolbarBackground(.bar, for: .navigationBar)
                                    .toolbarBackground(.visible, for: .navigationBar)
                            }).sheet(isPresented: $showAddNewTopic, content: {
                                NavigationView(content: {
                                    AddNewTopicView(selectedIcon: $selectedIcon, TopicName: $TopicName)
                                        .navigationBarTitle("New Topic")
                                        .navigationBarTitleDisplayMode(.inline)
                                        .toolbar {
                                            ToolbarItem(placement: .confirmationAction) {
                                                Button("Done") {
                                                    context.insert(Topics(label: TopicName, iconName: selectedIcon))
                                                    self.showAddNewTopic.toggle()
                                                }.foregroundStyle(.primaryColor1)
                                            }
                                            ToolbarItem(placement: .cancellationAction) {
                                                Button("Cancel") {
                                                    self.showAddNewTopic.toggle()
                                                }.foregroundStyle(.primaryColor1)
                                            }
                                        }.toolbarBackground(.bar, for: .navigationBar)
                                        .toolbarBackground(.visible, for: .navigationBar)
                                })
                            })
                        })
                }
            }
        } else{ CameraView(image: $image, isShown: $showCamera, recognizedData: $recognizedData)}
    }
    
    /// This function returns what kind of data is received (Full diagram, Not yet saved Diagram or nothing (needs to take picture). It returns the format in one of the following Strings: "diagram", "preDiagram" and "empty"
    func receivedInfoType() -> String {
        return self.diagram != nil ? "diagram" : (self.image != nil && !self.recognizedData.isEmpty) ? "preDiagram" : "empty"
    }
    
    /// MARK: "iPhoneVerticalView()"
    func iPhoneVerticalView() -> some View{
        VStack{
            GeometryReader { geo in
                Group {
                    /* A complete diagram is shown, with DiagramOverlayedView */
                    if receivedInfoType() == "diagram" {
                        ZoomView {
                            DiagramOverlayedView(uiImage: UIImage(data: diagram!.image!)!, labels: diagram!.labels, currentIndex: $currentIndex, overlayVisibility: $overlayVisibility, isQuiz: $isQuiz, isCorrect: Binding<Bool?>.constant(nil))
                        }
                    }
                    /* Before saving the diagram, we show a "pre-diagram", with DiagramOverlayedView but different parameters */
                    else if receivedInfoType() == "preDiagram"{
                        ZoomView {
                            DiagramOverlayedView(uiImage: image!, labels: tuppleToDiagramLabel(rectangles: recognizedData), currentIndex: $currentIndex, overlayVisibility: $overlayVisibility, isQuiz: $isQuiz, isCorrect: Binding<Bool?>.constant(nil))
                        }
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 50)
            
            /* All the buttons bellow the diagram depends on the diagram type */
            if receivedInfoType() == "diagram" {
                /* If it's a "diagram", the button is a navigation link to start the quiz */
                NavigationLink {
                    MainQuizView(diagram: diagram!, currentIndex: $currentIndex)
                } label: {
                    Text("Start Quizz")
                }.padding()
                    .background(.primaryColor1)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .buttonStyle(PlainButtonStyle())
            }
            else if receivedInfoType() == "preDiagram"{
                /* If it's a "prediagram" the button is just to save the diagram */
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
                        if receivedInfoType() == "diagram" {
                            ZoomView {
                                DiagramOverlayedView(uiImage: UIImage(data: diagram!.image!)!, labels: diagram!.labels, currentIndex: $currentIndex, overlayVisibility: $overlayVisibility, isQuiz: $isQuiz, isCorrect: Binding<Bool?>.constant(nil))
                            }
                        }
                        else if receivedInfoType() == "preDiagram"{
                            ZoomView {
                                DiagramOverlayedView(uiImage: image!, labels: tuppleToDiagramLabel(rectangles: recognizedData), currentIndex: $currentIndex, overlayVisibility: $overlayVisibility, isQuiz: $isQuiz, isCorrect: Binding<Bool?>.constant(nil))
                            }
                        }
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 50)
                if receivedInfoType() == "diagram" && !showWordReview{
                    NavigationLink {
                        MainQuizView(diagram: diagram!, currentIndex: $currentIndex)
                    } label: {
                        Text("Start Quizz")
                            .font(.title3)
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
        }.onDisappear{
            print(receivedInfoType(),"\n",diagram,"\n",recognizedData)
            if receivedInfoType() == "preDiagram"{
                let newDiagram:Diagram = Diagram(name:"", date: Date.now,labels:tuppleToDiagramLabel(rectangles: recognizedData), image: image?.pngData(), score: [], QuizDificulty: .easy, topic: selectingTopic)
                context.insert(newDiagram)
                diagram = newDiagram
            } else if (receivedInfoType() == "diagram" && selectingTopic != nil) {
                diagram!.topic = selectingTopic
            }
        }
    }
}
