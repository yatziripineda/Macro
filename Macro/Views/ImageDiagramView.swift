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
                    } label: {
                        Image(systemName: "pencil.line")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}
