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



struct TopicDetail: View {
    @State private var activity: Activities = .diagrams
    @State private var showRectangle = true
    @State private var textPosition: CGFloat = 10 // Variable para almacenar la posición del texto
    var topic: Topic?

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
            Spacer()
            Text("Recipe details go here")
                .navigationTitle(topic?.localizednavigationTitle ?? "")

            Spacer()
        }
    }
}


#Preview {
    TopicDetail()
}

