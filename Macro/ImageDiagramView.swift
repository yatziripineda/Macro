//
//  ImageDiagramView.swift
//  Macro
//
//  Created by yatziri on 14/05/24.
//

import SwiftUI

struct ImageDiagramView: View {
    @State private var showQuizz = false
    var diagram: DiagramInfo
    
    var body: some View {
        NavigationStack {
            VStack{
                ProgressView(value: diagram.statistics)
                    .tint(.orange)
                    .padding()
                    .scaleEffect(x: 1, y: 10)
                    .cornerRadius(4.0)
                    .frame(width: 600)
                Image(diagram.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: "999999").opacity(0.50)
                                    , lineWidth: 2)
                    )
                    .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 4)
                    .padding()
                    .padding(.horizontal, 80.0)
                Button("Quizz") {
                    self.showQuizz = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .buttonStyle(PlainButtonStyle())
            }
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "eye.slash.fill")
                            .foregroundColor(.blue)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
//                        BugSolveView(rectangles: $recognizedData)
                    } label: {
                        Image(systemName: "pencil.line")
                        .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

#Preview {
    ImageDiagramView(diagram: DiagramInfo(image: "ImagenPrueba", label: "Diagram 1", statistics: 0.5))
}
