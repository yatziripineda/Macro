//
//  MainQuizView.swift
//  Macro
//
//  Created by Jose Miguel Torres Chavez Nava on 05/06/24.
//

import SwiftUI

struct MainQuizView: View {
    
    var diagram: Diagram
    
    @Environment(\.presentationMode) var presentationMode
    
    // Manage the visibility of the overlay
    @State var overlayVisibility: Bool = true
    // Word is the string that the user write or select
    @State private var word: String = ""
    @State private var countCorrect: Int = 0
    // State variable that makes the array of words used for the EasyQuizzView()
    @State private var WordsForQuiz: [String] = []
    // State variable to track the correctness of the answer
    @State private var isAnswerCorrect: Bool? = nil
    // State variable to restart the state of the buttons
    @State private var buttonsActive: [Bool] = []
    // State variable to track the visibility of a feedback message on the HardQuizView
    @State private var MessageQuizState: Bool = false
    // State variable to track the text of a feedback message on the HardQuizView
    @State private var message: String = ""
    // State variable to track the visibility of the TextField on the HardQuizView
    @State private var TextFieldQuizState: Bool = false
    // Variable para mostrar el rectángulo rojo
    @State private var isQuiz: Bool = true
    // Variable para reconocer el botón seleccionado y poder separarlo del ForEach.
    @State private var indexSelectedButton: Int? = nil
    // Variable necesaria para el botón de next
    @State private var isChecked: Bool = false
    
    @Binding var currentIndex: Int

    var body: some View {
        NavigationStack {
            Group {
                // Si se está usando un iPhone, usamos la vista del iPhone
                if UIDevice.current.userInterfaceIdiom == .phone  {
                    iPhoneVerticalView()
                } else {
                    iPadHorizontalView()
                }
            }
            .onChange(of: currentIndex) {
                // Lógica para actualizar la puntuación del usuario.
                if currentIndex == diagram.labels.count {
                    diagram.score.append(Float(countCorrect) / Float(diagram.labels.count))
                    if diagram.score.last == 1 {
                        increaseDifficulty()
                    }
                } else {
                    if diagram.QuizDificulty == .easy {
                        initializeQuizData()
                    }
                }
            }
            .onAppear {
                currentIndex = 0
                if diagram.QuizDificulty == .easy {
                    initializeQuizData()
                }
            }
        }
    }
    
    /// Aquí tal vez se deba mejorar la lógica para poder hacer un ciclo de estudio de diagramas.
    func increaseDifficulty() {
        switch diagram.QuizDificulty {
        case .easy:
            diagram.QuizDificulty = .medium
        case .medium:
            diagram.QuizDificulty = .hard
        case .hard:
            diagram.QuizDificulty = .hard
        }
    }
    
    /// Esta función inicializa los valores con los que se va a trabajar en el Quiz.
    func initializeQuizData() {
        WordsForQuiz = createRandomWords()
        isAnswerCorrect = nil
        buttonsActive = Array(repeating: false, count: WordsForQuiz.count)
    }
    
    /// MARK: Funcion that generate a array of lables from diagram.lable
    func createRandomWords() -> [String] {
        var arrayWords = [String]()
        for index in 0..<diagram.labels.count {
            arrayWords.append(diagram.labels[index].text)
        }
        arrayWords.remove(at: currentIndex)
        arrayWords.shuffle()
        arrayWords.insert(diagram.labels[currentIndex].text, at: 0)
        var subArray = Array(arrayWords.prefix(diagram.labels.count > 6 ? 6 : 3))
        subArray.shuffle()
        return subArray
    }
    
    func quizViewForDifficulty() -> some View {
        switch diagram.QuizDificulty {
        case .easy:
            return AnyView(EasyQuizView(diagram: diagram, currentIndex: $currentIndex, WordsForQuiz: $WordsForQuiz, indexSelectedButton: $indexSelectedButton, isChecked: $isChecked, buttonsActive: $buttonsActive, isAnswerCorrect: $isAnswerCorrect, countCorrect: $countCorrect))
        case .medium:
            return AnyView(MediumQuizView(diagram: diagram, currentIndex: $currentIndex, word: $word, isAnswerCorrect: $isAnswerCorrect, TextFieldQuizState: $TextFieldQuizState, countCorrect: $countCorrect))
        case .hard:
            return AnyView(HardQuizView(diagram: diagram, currentIndex: $currentIndex, word: $word, isAnswerCorrect: $isAnswerCorrect, TextFieldQuizState: $TextFieldQuizState, countCorrect: $countCorrect))
        }
    }
    
    /// MARK: QuizzView for iPad
    func iPadHorizontalView() -> some View {
        VStack {
            if let imageData = diagram.image, let _ = UIImage(data: imageData) {
                GeometryReader { geo in
                    Group {
                        if let imageData = diagram.image, let uiImage = UIImage(data: imageData) {
                            ZoomView {
                                DiagramOverlayedView(uiImage: uiImage, labels: diagram.labels, currentIndex: $currentIndex, overlayVisibility: $overlayVisibility, isQuiz: $isQuiz)
                            }
                        }
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                }
                .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 4)
                .ignoresSafeArea()
            }
            if currentIndex != diagram.labels.count {
                quizViewForDifficulty()
                    .padding()
            }
        }
        // La vista de la puntuación se presenta cuando el índice se iguala al número de labels.
        .sheet(isPresented: .constant(currentIndex == diagram.labels.count), content: {
            ResultsView(diagram: diagram)
        })
    }
    
    /// MARK: QuizzView for iPhone
    func iPhoneVerticalView() -> some View {
        VStack {
            GeometryReader { geo in
                Group {
                    if let imageData = diagram.image, let uiImage = UIImage(data: imageData) {
                        ZoomView {
                            DiagramOverlayedView(uiImage: uiImage, labels: diagram.labels, currentIndex: $currentIndex, overlayVisibility: $overlayVisibility, isQuiz: $isQuiz)
                        }
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 50)
            
            /* Esta es la lógica para mostrar la vista de resultados en el iPhone */
            if currentIndex != diagram.labels.count {
                quizViewForDifficulty()
            } else {
                VStack {
                    if let lastScore = diagram.score.last {
                        Text("Congratulations! You have Scored \(lastScore)")
                    } else {
                        Text("Congratulations!")
                    }
                    Button("RETURN") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .frame(width: 470)
                }
            }
            /* Pero no parece estar muy bien implementada. */
        }
    }
}
