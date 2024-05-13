//
//  QuizzView.swift
//  Macro
//
//  Created by yatziri on 09/05/24.
//

import SwiftUI

struct QuizzView: View {
    var rectangles: [(String, CGRect)]
    @State private var word: String = ""
    @Binding var currentIndex: Int
    @State private var message: String = ""

    
    
    var body: some View {
       
        TextField("",
                  text: $word,
                  prompt: Text("What is this?")
            .foregroundColor(.black.opacity(0.4))
        )
        .padding(12)
        .background(.gray.opacity(0.1))
        .cornerRadius(8)
        .foregroundColor(.primary)
        .padding()
        Button {
            checkAnswer()
        } label: {
            Text("Check")
                .foregroundColor(.white)
                .padding()
                .frame(width: 200, height: 50)
                .background(Color.blue)
                .cornerRadius(10)
        }
        
        Text(message)
            .padding()
    }
    func checkAnswer() {
        print(rectangles[currentIndex].0)
            if currentIndex < rectangles.count {
                let (correctAnswer, _) = rectangles[currentIndex]
                if word == correctAnswer {
                    message = "Correct!"
                    currentIndex += 1
                    word = ""
                } else {
                    message = "Try again"
                }
            } else {
                message = "Quiz completed"
            }
        }
}

#Preview {
    QuizzView(rectangles: [("Exampl1", CGRect(x: 100, y: 50, width: 200, height: 50)),
                           ("Example2", CGRect(x: 50, y: 200, width: 250, height: 50))], currentIndex: .constant(1))
}
