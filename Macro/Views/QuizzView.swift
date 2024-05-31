//
//  QuizzView.swift
//  Macro
//
//  Created by yatziri on 09/05/24.
//

import SwiftUI

struct QuizzView: View {
    
    var diagram: Diagram
    
    // added this var to dismiss the view latter
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    // Created to hide keyboard after you send the guess on IPhoneVerticalView()
    @FocusState private var isTextFieldFocused: Bool
    
    // word is the string that the user write or select
    @State private var word: String = ""
    @State private var countCorrect: Int = 0
    
    // State variable that makes the array of words used for the EasyQuizzView()
    @State private var WordsForQuiz: [String] = []
    // State variable to track the correctness of the answer
    @State private var isAnswerCorrect: Bool? = nil
    // State variable to restart the state of the buttons
    @State private var buttonsActive: [Bool] = []
    //This variable detects if the buton is press so the other buttons are "desactivated"
    @State private var FirstButtonSelected: Bool = false
    // State variable to track the visiviliti of a feedbak message on the HardQuizView
    @State private var MessageQuizState: Bool = false
    // State variable to track the text of a feedbak message on the HardQuizView
    @State private var message: String = ""
    // State variable to track the visivility of the TextField on the HardQuizView
    @State private var TextFieldQuizState: Bool = false
    
    @Binding var currentIndex: Int
    //Adding this one to manage visibility of the overlay
    @State var overlayVisibility:Bool = true
    
    @GestureState private var dragState = CGSize.zero
    var IsIphone:Bool{
        if UIDevice.current.userInterfaceIdiom == .phone {
            return true
        }else{
            return false
        }
    }
    
    /// MARK: MainQuizzView
    var body: some View {
        NavigationStack{
            Group {
                if !IsIphone {
                    iPadHorizontalView()
                } else {
                    iPhoneVerticalView()
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
    
    
    
    func initializeQuizData() {
        WordsForQuiz = createRandomWords()
        FirstButtonSelected = false
        isAnswerCorrect = nil
        buttonsActive = Array(repeating: false, count: WordsForQuiz.count)
    }
    
    
    
    /// MARK: Logic of the Quizz evaluation
    func checkAnswer(UserText:String) {
        if currentIndex < diagram.labels.count {
            let correctAnswer = diagram.labels[currentIndex].text
            if UserText.capitalized == correctAnswer.capitalized {
                countCorrect += 1
                isAnswerCorrect = true
                print("Correct: \(countCorrect)")
            } else {
                isAnswerCorrect = false
            }
        }
    }
    
    
    
    /// MARK: Funcion that generate a array of Lables from diagram.lable
    func createRandomWords() -> [String] {
        var arrayWords = [String]()
        
        for index in 0..<diagram.labels.count {
            arrayWords.append(diagram.labels[index].text)
        }
        arrayWords.remove(at: currentIndex)
        arrayWords.shuffle()
        arrayWords.insert(diagram.labels[currentIndex].text, at: 0)
        var subArray = Array(arrayWords.prefix(diagram.labels.count > 6 ? 6:3 ))
        subArray.shuffle()
        return subArray
    }
    
    func quizViewForDifficulty() -> some View {
        switch diagram.QuizDificulty {
        case .easy:
            return AnyView(EasyQuizzView())
        case .medium:
            return AnyView(MediumQuizzView())
        case .hard:
            return AnyView(HardQuizzView())
        }
    }
    
    
    
    /// MARK: QuizzView for iPad
    func iPadHorizontalView() -> some View {
        VStack{
            if let imageData = diagram.image, let _ = UIImage(data: imageData) {
                GeometryReader { geo in
                    Group {
                        if let imageData = diagram.image, let uiImage = UIImage(data: imageData) {
                            ZoomView {
                                DiagramOverlayedView(uiImage: uiImage, labels: diagram.labels, currentIndex: $currentIndex, overlayVisibility: $overlayVisibility)
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
            CongratulationView()
        })
    }
    
    
    
    
    /// MARK: QuizzView for iPhone
    func iPhoneVerticalView() -> some View {
        VStack{
            if let imageData = diagram.image,
               let uiImage = UIImage(data: imageData){
                GeometryReader { geo in
                    Group {
                        if let imageData = diagram.image, let uiImage = UIImage(data: imageData) {
                            ZoomView {
                                DiagramOverlayedView(uiImage: uiImage, labels: diagram.labels, currentIndex: $currentIndex, overlayVisibility: $overlayVisibility)
                            }
                        }
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 50)
            }
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
        }
    }
    
    
    
    
    /// MARK: Easy Quizz view
    func EasyQuizzView() -> some View {
        VStack {
            Text("What is this?")
                .font(.title)
                .bold()
            // Using LazyVGrid for a vertical grid layout
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16),GridItem(.flexible(), spacing: 16)], spacing: 40) {
                
                ForEach(0..<WordsForQuiz.count, id: \.self) { index in
                    Button(action: {
                        if FirstButtonSelected == false {
                            FirstButtonSelected = true
                            checkAnswer(UserText: WordsForQuiz[index])
                            // Reset buttonsActive array and hide symbols
                            buttonsActive = Array(repeating: false, count: WordsForQuiz.count)
                            // Activate selected button
                            buttonsActive[index] = true
                        }
                    }) {
                        HStack {
                            Text(WordsForQuiz[index])
                                .padding()
                                .frame(width: 200,height: 45)
                        }
                        .padding(.horizontal)
                        .background(
                            buttonsActive[index] ? (isAnswerCorrect ?? false ? Color.green.opacity(0.3) : Color.red.opacity(0.3)) : Color(hex: "F2F2F7")
                        )
                        .foregroundColor(
                            buttonsActive[index] ? (isAnswerCorrect ?? false ? .black : .black) : .black
                        )
                        .cornerRadius(20)
                        .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 4)
                    }
                }
            }
            
            .padding()
            .toolbar{
                ToolbarItem{
                    ProgressView(value: Float(currentIndex), total: Float(diagram.labels.count))
                        .tint(Color.primaryColor1)
                        .scaleEffect(y: 20)
                        .frame(width: 810)
                        .cornerRadius(20.0)
                        .position(x: UIScreen.main.bounds.width / 5)
                        .padding()

                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        currentIndex += 1
                        FirstButtonSelected = false
                    }){
                        HStack{
                            Text("Next")
                            Image(systemName: "chevron.forward")
                        }
                        .padding()
                        .foregroundStyle(
                            FirstButtonSelected ? Color.primaryColor1 : Color(hex: "DCDCDD")
                        )
                    }
                    .disabled(!FirstButtonSelected)
                }
            }
        }
        .frame(width: 780)
    }
    
    
    /// MARK: Medium Quizz view
    func MediumQuizzView() -> some View{
        VStack(alignment: .leading){
            Text("What is this?")
                .font(.largeTitle)
                .bold()
                .padding(.horizontal)
            Text("Complete the name of the element")
                .font(.body)
                .foregroundStyle(Color.gray)
                .padding(.horizontal)
            HStack{
                TextField("",
                          text: $word
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
                    //disabled the textfield
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
            .onAppear(){
                if !(currentIndex == diagram.labels.count  ){
                    word = String(diagram.labels[currentIndex].text.prefix(1).capitalized)
                }
            }
            .onChange(of: word) {
                if !(currentIndex == diagram.labels.count  ){
                    if word == ""{
                        word = String(diagram.labels[currentIndex].text.prefix(1).capitalized)
                    }
                }
            }
            .toolbar{
                ToolbarItem{
                    ProgressView(value: Float(currentIndex), total: Float(diagram.labels.count))
                        .tint(Color.primaryColor1)
                        .scaleEffect(y: 20)
                        .frame(width: 810)
                        .cornerRadius(20.0)
                        .position(x: UIScreen.main.bounds.width / 5)
                        .padding()

                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        currentIndex += 1
                        TextFieldQuizState = false
                        word = ""
                    }){
                        HStack{
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
    
    
    
    
    
    /// MARK: Hard Quizz view
    func HardQuizzView() -> some View{
        VStack(alignment: .leading){
            Text("What is this?")
                .font(.largeTitle)
                .bold()
                .padding(.horizontal)
            Text("Write the name of the element ")
                .font(.body)
                .foregroundStyle(Color.gray)
                .padding(.horizontal)
            HStack{
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
                    //disabled the textfield
                    TextFieldQuizState = true
                    checkAnswer(UserText: word)
                    print("Label:\(diagram.labels[currentIndex].text)")
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
            .toolbar{
                ToolbarItem{
                    ProgressView(value: Float(currentIndex), total: Float(diagram.labels.count))
                        .tint(Color.primaryColor1)
                        .scaleEffect(y: 20)
                        .frame(width: 810)
                        .cornerRadius(20.0)
                        .position(x: UIScreen.main.bounds.width / 5)
                        .padding()
                    
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        currentIndex += 1
                        TextFieldQuizState = false
                        word = ""
                    }){
                        HStack{
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
    
    
    
    /// This view shows a message with the obtained score.
    func CongratulationView() -> some View {
        VStack{
            if let lastScore = diagram.score.last {
                let score = String(format: "%.2f", lastScore*100)
                if lastScore > 0.9 {
                    Text("🎉")
                        .font(.system(size: 150))
                        .padding()
                    Text("Congrats!")
                        .font(.system(size: 90))
                        .bold()
                        .padding()
                    Text("You scored \(score)%")
                        .font(.title2)
                        .padding()
                } else {
                    if lastScore > 0.6{
                        Text("👍🏻")
                            .font(.system(size: 150))
                            .padding()
                        Text("Good job!")
                            .font(.system(size: 90))
                            .bold()
                            .padding()
                        Text("You scored \(score)%")
                            .font(.title2)
                            .padding()
                    }else{
                        Text("🙂")
                            .font(.system(size: 150))
                            .padding()
                        Text("Keep practicing")
                            .font(.system(size: 90))
                            .bold()
                            .padding()
                        Text("You scored \(score)%")
                            .font(.title2)
                            .padding()
                    }
                }
            }
        }.foregroundStyle(Color.primaryColor2)
            .padding(20)
    }
}


