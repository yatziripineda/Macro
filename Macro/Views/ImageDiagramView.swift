//
//  ImageDiagramView.swift
//  Macro
//
//  Created by yatziri on 14/05/24.
//
//
//import SwiftUI
//
//struct ImageDiagramView: View {
////    @State private var showQuizz = false
//    @GestureState private var dragState = CGSize.zero
//    @State private var currentIndex: Int = 0
//    @State private var offset = CGSize.zero
//    var diagram: Diagram
//    
//    var body: some View {
//        NavigationStack {
//            VStack{
//                ProgressView(value: 0.70)
//                    .tint(.orange)
//                    .padding()
//                    .scaleEffect(x: 1, y: 10)
//                    .cornerRadius(4.0)
//                    .frame(width: 600)
//                if let imageData = diagram.image,
//                   let uiImage = UIImage(data: imageData){
//                    GeometryReader { geometry in
//                        ScrollView([.horizontal, .vertical], showsIndicators: true){
//                            Image(uiImage: uiImage)
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .cornerRadius(20)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 20)
//                                        .stroke(Color(hex: "999999").opacity(0.50)
//                                                , lineWidth: 2)
//                                )
//                                .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 4)
//                                .padding()
//                                .padding(.horizontal, 80.0)
//                                .offset(x: offset.width + dragState.width, y: offset.height + dragState.height)
//                                .overlay(RectanglesOverlay(labels: diagram.labels, currentIndex: $currentIndex))
//                                .gesture(
//                                    DragGesture()
//                                        .updating($dragState) { value, state, _ in
//                                            state = value.translation
//                                        }
//                                )
//                        }.frame(width: geometry.size.width, height: geometry.size.height)
//                    }
//                }
////                Image("ImagenPrueba")
////                    .resizable()
////                    .aspectRatio(contentMode: .fit)
////                    .cornerRadius(20)
////                    .overlay(
////                        RoundedRectangle(cornerRadius: 10)
////                            .stroke(Color(hex: "999999").opacity(0.50)
////                                    , lineWidth: 2)
////                    )
////                    .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 4)
////                    .padding()
////                    .padding(.horizontal, 80.0)
//                NavigationLink {
//                    QuizzView(diagram: diagram, currentIndex: $currentIndex)
//                } label: {
//                    Text("Start Quizz")
//                }
//                .padding()
//                .background(Color.orange)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//                .buttonStyle(PlainButtonStyle())
//            }
////            .sheet(isPresented: $showQuizz) {
////                QuizzView(diagram: diagram, currentIndex: $currentIndex)
////            }
//            .toolbar {
//                
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        
//                    }) {
//                        Image(systemName: "eye.slash.fill")
//                            .foregroundColor(.blue)
//                    }
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationLink {
////                        BugSolveView(rectangles: $recognizedData)
//                    } label: {
//                        Image(systemName: "pencil.line")
//                        .foregroundColor(.blue)
//                    }
//                }
//            }
//        }
//    }
//}
//
//
////#Preview {
////    ImageDiagramView(diagram: DiagramInfo(image: "ImagenPrueba", label: "Diagram 1", statistics: 0.5))
////}
//
//  ImageDiagramView.swift
//  Macro
//
//  Created by yatziri on 14/05/24.
//

import SwiftUI

/// This is the view showed when you open an specific diagram from the list in the main View.
struct ImageDiagramView: View {
    @GestureState private var dragState = CGSize.zero
    @State private var currentIndex: Int = 0
    @State private var offset = CGSize.zero
    var diagram: Diagram

    var body: some View {
        NavigationStack {
            VStack{
                ProgressView(value: 0.70)
                    .tint(.orange)
                    .padding()
                    .scaleEffect(x: 1, y: 10)
                    .cornerRadius(4.0)
                    .frame(width: 600)

                GeometryReader { geo in
                    Group {
                        if let imageData = diagram.image, let uiImage = UIImage(data: imageData) {
                            ZoomView {
                                ZStack {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                    RectanglesOverlay(labels: diagram.labels, currentIndex: $currentIndex)
                                }
                            }
                        }
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 50)

                NavigationLink {
                    QuizzView(diagram: diagram, currentIndex: $currentIndex)
                } label: {
                    Text("Start Quizz")
                }
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
                .buttonStyle(PlainButtonStyle())
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Action
                    }) {
                        Image(systemName: "eye.slash.fill")
                            .foregroundColor(.blue)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        // BugSolveView(rectangles: $recognizedData)
                    } label: {
                        Image(systemName: "pencil.line")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}
