//
//  DiagramButton.swift
//  Macro
//
//  Created by yatziri on 15/05/24.
//

import SwiftUI

struct DiagramButton: View {
    
    var diagram: Diagram
    
    var body: some View {
//        ZStack {
           
//            ZStack {
                VStack {
                    if let imageData = diagram.image,
                       let uiImage = UIImage(data: imageData){
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 190, height: 153)
                            .cornerRadius(20)
                            .clipped()
                    }
                    HStack {
                        Text(diagram.topic?.label ?? "Diagram without topic")
                            .foregroundColor(Color.primaryColor1)
                            .font(.footnote)
                            .bold().padding(.top,7)
                        Spacer()
                    }.padding(0)
//                    HStack {
//                        Spacer()
//                        Text("100%")
//                            .font(.footnote)
//                            .foregroundColor(Color.black.opacity(0.2))
//                    }
                }
                .padding()
                .frame(width: 190)
                .background {
                    BottomRoundedRectangle(cornerRadius: 20)
                        .frame(width: 190, height: 55)
                        .foregroundColor(Color.gray.opacity(0.2))
                }
            .offset(y: 5)
//        }
        .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 1)
    }
}


struct AddDiagramButton: View {
    
    
    var body: some View {
        ZStack {
            NavigationLink {
                ImageDiagramView()
            } label: {
                Image(systemName: "photo.badge.plus").resizable().aspectRatio(contentMode: .fit)
                .padding(.leading, 10)
                .foregroundColor(Color.primaryColor1)
                .padding()
                .frame(width: 100)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                        .frame(width: 190, height: 163)
                        .foregroundColor(Color.primaryColor1)
            }
                
            }
        }
    }
}
