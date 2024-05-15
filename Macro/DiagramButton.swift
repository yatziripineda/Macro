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
        ZStack {
            if let imageData = diagram.image,
               let uiImage = UIImage(data: imageData){
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 190, height: 163)
                    .cornerRadius(20)
                    .clipped()
            }
            ZStack {
                VStack {
                    HStack {
                        Text(diagram.name)
                            .foregroundColor(.black)
                            .font(.footnote)
                            .bold()
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text("100%")
                            .font(.footnote)
                            .foregroundColor(Color(hex: "3C3C43").opacity(0.60))
                    }
                }
                .padding()
                .frame(width: 190)
                .background {
                    BottomRoundedRectangle(cornerRadius: 20)
                        .frame(width: 190, height: 55)
                        .foregroundColor(Color(hex: "F1F1F1"))
                }
            }.offset(y: 54)
        }
        .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 4)
    }
}


//
//#Preview {
//    DiagramButton(diagram: Diagram(name: "Diagram", date: Date.now, labels: [DiagramLabel(text: "hola", rectangle: CGRect(x: 100, y: 50, width: 200, height: 50))], image: UIImage(named: "ImagenPrueba")?.pngData() ))
//}
