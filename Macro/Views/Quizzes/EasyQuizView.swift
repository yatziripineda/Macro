//
//  EasyQuizView.swift
//  Macro
//
//  Created by Jose Miguel Torres Chavez Nava on 05/06/24.
//

import SwiftUI

struct EasyQuizView: View {
    var diagram: Diagram
    @Binding var currentIndex: Int
    @Binding var WordsForQuiz: [String]
    @Binding var indexSelectedButton: Int?
    @Binding var isChecked: Bool
    @Binding var buttonsActive: [Bool]
    @Binding var isAnswerCorrect: Bool?
    @Binding var countCorrect: Int
    
    var body: some View {
        VStack {
            Text("What is this?")
                .font(.title)
                .bold()
            // Creamos los botones con todas las opciones, pero necesita espacio dinámico... ***
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 40) {
                ForEach(0..<WordsForQuiz.count, id: \.self) { index in
                    Button(action: {
                        /* "Toggle" para poder elegir la opción correcta con feedback */
                        if indexSelectedButton == index {
                            indexSelectedButton = nil
                        } else {
                            indexSelectedButton = index
                        }
                    }) {
                        HStack {
                            Text(WordsForQuiz[index])
                                .padding()
                                .frame(minWidth: 200)
                                .frame(height: 45)
                                .foregroundStyle(Color.black)
                        }
                        .padding(.horizontal)
                        .background(
                            buttonsActive[index] ? (isAnswerCorrect ?? false ? Color.green.opacity(0.3) : Color.red.opacity(0.3)) :
                                indexSelectedButton == index ? Color.blue : Color.gray.opacity(0.2)
                        )
                        .cornerRadius(20)
                        .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 4)
                    }.disabled(isChecked)
                }
            }
            .padding()
            
            // "Next" button for easy Quiz
            Button {
                if let index = indexSelectedButton {
                    checkAnswer(UserText: WordsForQuiz[index])
                    // Reset buttonsActive array and hide symbols
                    buttonsActive = Array(repeating: false, count: WordsForQuiz.count)
                    // Activate selected button
                    buttonsActive[index] = true
                    isChecked = true
                    indexSelectedButton = nil
                } else {
                    currentIndex += 1
                    isChecked = false
                }
            } label: {
                Text(isChecked ? "Next" : "Check")
                    .font(.title3)
                    .padding()
                    .background((indexSelectedButton == nil && !isChecked) ? Color.gray.opacity(0.2) : .primaryColor1)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .buttonStyle(PlainButtonStyle())
            }
            .disabled(indexSelectedButton == nil && !isChecked)
                
        }
        .frame(width: 780)
        // La toolbar de la barra de progreso tiene un detalle, tal vez sea bueno descartarla por ahora.
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
        }
    }

    /// MARK: Logic of the Quizz evaluation
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