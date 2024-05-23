//
//  ImageReviewView.swift
//  Macro
//
//  Created by Vitor Kalil on 21/05/24.
//

import SwiftUI

struct ImageReviewView: View {
    @State private var recognizedData: [(String, CGRect)] = []
    @State private var image: UIImage?
    @State private var showCamera = false
    @State private var showWordReview:Bool = false
    
    @GestureState private var dragState = CGSize.zero
    @State private var currentIndex: Int = 0
    @State private var offset = CGSize.zero
    var body: some View {
        if !recognizedData.isEmpty && image != nil {
            ZStack{
                if let imageData = image{
                    GeometryReader { geometry in
                        ScrollView([.horizontal, .vertical], showsIndicators: true){
                            Image(uiImage: imageData)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color(hex: "999999").opacity(0.50)
                                                , lineWidth: 2)
                                )
                                .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 4)
                                .padding()
                                .padding(.horizontal, 80.0)
                                .offset(x: offset.width + dragState.width, y: offset.height + dragState.height)
                                .overlay(RectanglesOverlay(labels: tuppleToDiagramLabel(rectangles: recognizedData), currentIndex: $currentIndex))
                                .gesture(
                                    DragGesture()
                                        .updating($dragState) { value, state, _ in
                                            state = value.translation
                                        }
                                )
                        }.frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
                Button("EDIT WORDS"){
                    showWordReview.toggle()
                }
            }.sheet(isPresented: $showWordReview, content: {
                WordReviewView(rectangles: $recognizedData, image: $image)
            })
        } else{
            CameraView(image: $image, isShown: $showCamera, recognizedData: $recognizedData)
        }
        
    }
    
}

func tuppleToDiagramLabel(rectangles:[(String,CGRect)]) -> [DiagramLabel]{
    var tupleList:[DiagramLabel] = []
    for (s,r) in rectangles{
        tupleList.append(DiagramLabel(text: s, rectangle: r))
    }
    return tupleList
}
//#Preview {
//    ImageReviewView()
//}
