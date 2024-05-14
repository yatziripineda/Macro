//
//  TopicDetail.swift
//  Macro
//
//  Created by yatziri on 13/05/24.
//
import SwiftUI

enum Activities {
    case diagrams
    case diagrams1
    var ActivitiesText: String{
        switch self {
        case .diagrams:
            return "Diagrams"
        case .diagrams1:
            return "Diagrams1"
        }
    }
}
struct DiagramInfo: Hashable {
    let id = UUID()
    let image: String
    let label: String
    let statistics: Int
    
    // Implementación de Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(image)
        hasher.combine(label)
        hasher.combine(statistics)
    }
    
    static func ==(lhs: DiagramInfo, rhs: DiagramInfo) -> Bool {
            return lhs.id == rhs.id &&
                lhs.image == rhs.image &&
                lhs.label == rhs.label &&
                lhs.statistics == rhs.statistics
        }
}


struct TopicDetail: View {
    @State private var activity: Activities = .diagrams
    @State private var showRectangle = true
    @State private var textPosition: CGFloat = 10
    
    var topic: Topic?
    
    let diagrams: [DiagramInfo] = [
            DiagramInfo(image: "ImagenPrueba", label: "Diagram 1", statistics: 75),
            DiagramInfo(image: "ImagenPrueba", label: "Diagram 1", statistics: 60),
            DiagramInfo(image: "ImagenPrueba", label: "Diagram 1", statistics: 90),
            DiagramInfo(image: "ImagenPrueba", label: "Diagram 1", statistics: 75),
            DiagramInfo(image: "ImagenPrueba", label: "Diagram 5", statistics: 60),
            DiagramInfo(image: "ImagenPrueba", label: "Diagram 6", statistics: 90),
            DiagramInfo(image: "ImagenPrueba", label: "Diagram 7", statistics: 75),
            DiagramInfo(image: "ImagenPrueba", label: "Diagram 8", statistics: 60),
            DiagramInfo(image: "ImagenPrueba", label: "Diagram 9", statistics: 90)
            
        ]

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        activity = .diagrams
                        textPosition = 10
                    }) {
                        Text("Diagrams")
                            .font(.title3)
                            .foregroundColor(activity == .diagrams ? .black : .gray)
                    } .padding()
                    Button(action: {
                        activity = .diagrams1
                        textPosition = 130
                    }) {
                        Text("Diagrams1")
                            .font(.title3)
                            .foregroundColor(activity == .diagrams1 ? .black : .gray)
                    }
                    .padding()
                    Spacer()
                }
                
                Rectangle()
                    .frame(width: 110, height: 5)
                    .foregroundColor(.black)
                    .padding(.horizontal, textPosition)
                    .padding(.bottom, -30.0)
                Divider()
            }
            ScrollView{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 190))], spacing: 10) {
                    ForEach(diagrams, id: \.self) { diagram in
                        DiagramButton(diagram: diagram)
                            .id(diagram.id)
                            .padding()
                    }
                }
                .padding()
            }
            .padding()
            Spacer()
                .navigationTitle(topic?.localizednavigationTitle ?? "")
        }
    }
}
struct BottomRoundedRectangle: Shape {
    var cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
        path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
        path.closeSubpath()

        return path
    }
}

#Preview {
    TopicDetail()
}


struct DiagramButton: View {
    var diagram: DiagramInfo
    
    var body: some View {
        ZStack {
            Image(diagram.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 190, height: 163)
                .cornerRadius(20)
                .clipped()
            ZStack {
                VStack {
                    HStack {
                        Text(diagram.label)
                            .font(.footnote)
                            .bold()
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text("\(diagram.statistics)%")
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


#Preview {
    DiagramButton(diagram: DiagramInfo(image: "ImagenPrueba", label: "Diagram 1", statistics: 75))
}
