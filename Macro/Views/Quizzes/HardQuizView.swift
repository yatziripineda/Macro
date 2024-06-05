//
//  HardQuizView.swift
//  Macro
//
//  Created by Jose Miguel Torres Chavez Nava on 05/06/24.
//

import SwiftUI

struct HardQuizView: View {
    var diagram: Diagram
    @Binding var currentIndex: Int
    @Binding var word: String
    @Binding var isAnswerCorrect: Bool?
    @Binding var TextFieldQuizState: Bool
    @Binding var countCorrect: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text("What is this?")
                .font(.largeTitle)
                .bold()
                .padding(.horizontal)
            Text("Write the name of the element")
                .font(.body)
                .foregroundStyle(Color.gray)
                .padding(.horizontal)
            HStack {
                TextField("",
                          text: $word,
                          prompt: Text("Type here...")
                    .foregroundColor(.black.opacity(0.4))
                )
                .disabled(TextFieldQuizState)
                .padding(12)
                .background(
                    isAnswerCorrect == nil
                    ? Color.gray.opacity(0.1)
                    : (isAnswerCorrect! ? Color.green.opacity(0.3) : Color.red.opacity(0.3))
                )
                .cornerRadius(8)
                .foregroundColor(.primary)
                .padding()
                Button {
                    // Disabled the textfield
                    TextFieldQuizState = true
                    checkAnswer(UserText: word)
                    print("Label: \(diagram.labels[currentIndex].text)")
                } label: {
                    Text("Check")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 138, height: 45)
                        .background(Color.primaryColor1)
                        .overlay(
                            Rectangle()
                                .frame(height: 4)
                                .foregroundColor(.primaryColor2),
                            alignment: .bottom
                        )
                        .cornerRadius(10)
                    
                }.disabled(word == "")
            }
            .toolbar {
                ToolbarItem {
                    ProgressView(value: Float(currentIndex), total: Float(diagram.labels.count))
                        .tint(Color.primaryColor1)
                        .scaleEffect(y: 20)
                        .frame(width: 810)
                        .cornerRadius(20.0)
                        .position(x: UIScreen.main.bounds.width / 5)
                        .padding()
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        currentIndex += 1
                        TextFieldQuizState = false
                        word = ""
                    }) {
                        HStack {
                            Text("Next")
                            Image(systemName: "chevron.forward")
                        }
                        .padding()
                        .foregroundStyle(
                            TextFieldQuizState ? Color.primaryColor1 : Color(hex: "DCDCDD")
                        )
                    }
                    .disabled(!TextFieldQuizState)
                }
            }
        }
        .frame(width: 780)
    }

    func checkAnswer(UserText: String) {
        if currentIndex < diagram.labels.count {
            let correctAnswer = diagram.labels[currentIndex].text
            if UserText.capitalized == correctAnswer.capitalized {
                countCorrect += 1
                isAnswerCorrect = true
            } else {
                isAnswerCorrect = false
            }
        }
    }
}
