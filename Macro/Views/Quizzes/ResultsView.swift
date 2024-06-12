//
//  ResultsView.swift
//  Macro
//
//  Created by Jose Miguel Torres Chavez Nava on 05/06/24.
//

import SwiftUI

struct ResultsView: View {
    
    var diagram: Diagram
    var isPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone

    var body: some View {
        VStack {
            if let lastScore = diagram.score.last {
                let score = String(format: "%.2f", lastScore * 100)
                if lastScore > 0.9 {
                    Text("🎉")
                        .font(.system(size: isPhone ? 50 : 150))
                        .padding()
                    Text("Congrats!")
                        .font(.title)
                        .bold()
                        .padding()
                    Text("You scored \(score)%")
                        .font(.title2)
                        .padding()
                } else if lastScore > 0.6 {
                    Text("👍🏻")
                        .font(.system(size: isPhone ? 50 : 150))
                        .padding()
                    Text("Good job!")
                        .font(.title)
                        .bold()
                        .padding()
                    Text("You scored \(score)%")
                        .font(.title2)
                        .padding()
                } else {
                    Text("🙂")
                        .font(.system(size: isPhone ? 50 : 150))
                        .padding()
                    Text("Keep practicing")
                        .font(.title)
                        .bold()
                        .padding()
                    Text("You scored \(score)%")
                        .font(.title2)
                        .padding()
                }
            }
        }
        .foregroundStyle(Color.primaryColor2)
        .padding(20)
    }
}
