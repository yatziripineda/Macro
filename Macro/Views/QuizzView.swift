//
//  QuizzView.swift
//  Macro
//
//  Created by yatziri on 09/05/24.
//

import SwiftUI

struct QuizzView: View {
    //var rectangles: [DiagramLabel]
    var diagram:Diagram
    
    // added this var to dismiss the view latter
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.managedObjectContext) private var viewContext
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
    // State variable to track the visiviliti of the TextField on the HardQuizView
    @State private var TextFieldQuizState: Bool = false

    
    @Binding var currentIndex: Int
    
    @GestureState private var dragState = CGSize.zero
    // Created to hide keyboard after you send the guess on IPhoneVerticalView()
    @FocusState private var isTextFieldFocused: Bool

 
    
    
    //MARK: MainQuizzView
    var body: some View {
        Group {
            if UIDevice.current.userInterfaceIdiom == .phone {
                iPhoneVerticalView()
            } else {
                iPadHorizontalView()
            }
        }
        .onChange(of: currentIndex) {
                    if currentIndex == diagram.labels.count {
                        diagram.score.append(Float(countCorrect) / Float(diagram.labels.count))
                        if diagram.score.last == 1 {
                            print(diagram.QuizDificulty)
                            increaseDifficulty()
                            print(diagram.QuizDificulty)
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
    
    func increaseDifficulty() {
        switch diagram.QuizDificulty {
        case .easy:
            diagram.QuizDificulty = .medium
        case .medium:
            diagram.QuizDificulty = .hard
        case .hard:
            diagram.QuizDificulty = .hard
        }
//        saveContext()
    }
    func initializeQuizData() {
            WordsForQuiz = createRandomWords()
            FirstButtonSelected = false
            isAnswerCorrect = nil
            buttonsActive = Array(repeating: false, count: WordsForQuiz.count)
        }
    
    //MARK: Logic of the Quizz evaluation
    
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
    
    //MARK: Funcion that generate a array of Lables from diagram.lable
    func createRandomWords() -> [String] {
        var arrayWords = [String]()
            
        for index in 0..<diagram.labels.count {
            arrayWords.append(diagram.labels[index].text)
        }
        arrayWords.remove(at: currentIndex)
        arrayWords.shuffle()
        arrayWords.insert(diagram.labels[currentIndex].text, at: 0)
        
        var subArray = Array(arrayWords.prefix(5))
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
    
    //MARK: Quizz View IPad
    //IPad on Horizontal Orientation View
    func iPadHorizontalView() -> some View{
        HStack{
            if let imageData = diagram.image,
               let uiImage = UIImage(data: imageData){
                GeometryReader { geometry in
                    ScrollView([.horizontal, .vertical], showsIndicators: true){
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(20)
                            .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 4)
                            .padding()
                            .padding(.horizontal, 80.0)
                            .overlay(RectanglesOverlay(labels: diagram.labels, currentIndex: $currentIndex))
                            .gesture(
                                DragGesture()
                                    .updating($dragState) { value, state, _ in
                                        state = value.translation
                                    }
                            )
                    }.frame(width: geometry.size.width, height: geometry.size.height)
                }
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
    
    
    //MARK: Quizz View IPhone
    //IPhone on Vertical Orientation View
    func iPhoneVerticalView() -> some View{
        VStack{
            if let imageData = diagram.image,
               let uiImage = UIImage(data: imageData){
                GeometryReader { geometry in
                    ScrollView([.horizontal, .vertical], showsIndicators: true){
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(20)
                            .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 4)
                            .padding()
                            .padding(.horizontal, 80.0)
                            .overlay(RectanglesOverlay(labels: diagram.labels, currentIndex: $currentIndex))
                            .gesture(
                                DragGesture()
                                    .updating($dragState) { value, state, _ in
                                        state = value.translation
                                    }
                            )
                    }.frame(width: geometry.size.width, height: geometry.size.height)
                }
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
    
    //MARK: Easy Quizz view
    func EasyQuizzView() -> some View {
        VStack {
            Text("What is this?")
                .font(.title3)
                .bold()
            // Using LazyVGrid for a vertical grid layout
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                
                ForEach(0..<WordsForQuiz.count, id: \.self) { index in
                    Button(action: {
                        if FirstButtonSelected == false{
                            FirstButtonSelected = true
                            checkAnswer(UserText: WordsForQuiz[index])
                            // Reset buttonsActive array and hide symbols
                            buttonsActive = Array(repeating: false, count: WordsForQuiz.count)
                            // Activate selected button
                            buttonsActive[index] = true
                        }
                    }) {
                        HStack {
                            if buttonsActive[index] {
                                if WordsForQuiz[index] == diagram.labels[currentIndex].text {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                } else {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                            else {
                                Image(systemName: "circlebadge")
                                    .foregroundColor(.gray)
                            }
                            Text(WordsForQuiz[index])
                                .padding()
                                .frame(height: 45)
                        }
                        .padding(.horizontal)
                        .background(
                            buttonsActive[index] ? (isAnswerCorrect ?? false ? Color.green.opacity(0.2) : Color.red.opacity(0.2)) : Color(hex: "F2F2F7")
                        )
                        .foregroundColor(
                            buttonsActive[index] ? (isAnswerCorrect ?? false ? .green : .red) : .black
                        )
                        .cornerRadius(20)
                        .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 4)
                    }
                }
            }
            .padding()
            if FirstButtonSelected {
                Button(action: {
                    currentIndex += 1
                    FirstButtonSelected = false
                }){
                    HStack{
                        Text("Next")
                        Image(systemName: "greaterthan")
                    }
                    .padding()
                }
            }
        }.frame(width: 470)
    }
    

    //MARK: Medium Quizz view
    func MediumQuizzView() -> some View{
        VStack{
            Text("What is this?")
                .font(.title3)
                .bold()
            TextField("",
                      text: $word
            )
            .disabled(TextFieldQuizState)
            .padding(12)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.primary)
            .padding()
            
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
            if MessageQuizState {
                Text(message)
                    .padding()
                    Button{
                        currentIndex += 1
                        MessageQuizState = false
                        TextFieldQuizState = false
                        word = ""
                    }label: {
                        if !(currentIndex == diagram.labels.count - 1  ){
                            HStack{
                                Text("Next")
                                Image(systemName: "greaterthan")
                            }
                            .padding()
                        }else{
                            HStack{
                                Text("Finish")
                            }
                            .padding()
                        }
                    }
            }else{
                Button {
                    TextFieldQuizState = true
                    MessageQuizState = true
                    checkAnswer(UserText: word)
                    print("Lable:\(diagram.labels[currentIndex].text)")
                    if word == diagram.labels[currentIndex].text{
                        message = "Correct!"
                    }else{
                        message = "Wrong The correct Answer is: \(diagram.labels[currentIndex].text)"
                    }
                } label: {
                    Text("Check")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }.disabled(word == "")
            }
          
        }.frame(width: 300)
    }
    
    //MARK: Hard Quizz view
    func HardQuizzView() -> some View{
        VStack{
            TextField("",
                      text: $word,
                      prompt: Text("What is this?")
                .foregroundColor(.black.opacity(0.4))
            )
            .disabled(TextFieldQuizState)
            .padding(12)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.primary)
            .padding()
            
            if MessageQuizState {
                Text(message)
                    .padding()
                    Button{
                        currentIndex += 1
                        MessageQuizState = false
                        TextFieldQuizState = false
                        word = ""
                    }label: {
                        HStack{
                            Text("Next")
                            Image(systemName: "greaterthan")
                        }
                        .padding()
                    }
            }else{
                Button {
                    TextFieldQuizState = true
                    MessageQuizState = true
                    checkAnswer(UserText: word)
                    print("Lable:\(diagram.labels[currentIndex].text)")
                    if word == diagram.labels[currentIndex].text{
                        message = "Correct!"
                    }else{
                        message = "Wrong The correct Answer is: \(diagram.labels[currentIndex].text)"
                    }
                } label: {
                    Text("Check")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }.disabled(word == "")
            }
          
        }.frame(width: 300)
    }
}


//#Preview {
//    QuizzView(diagram:Diagram(name:"",date:Date.now,labels: [DiagramLabel(text: "String", rectangle: CGRect(x: 0, y: 0, width: 100, height: 100)),DiagramLabel(text: "String", rectangle: CGRect(x: 0, y: 0, width: 100, height: 100))], image:UIImage(named: "ImagenPrueba")?.pngData()), currentIndex: .constant(1))
//}
