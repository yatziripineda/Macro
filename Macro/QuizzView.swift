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
    // word is the string that the user write or select
    @State private var word: String = ""
    
    @State private var message: String = ""
    
    @State private var countCorrect: Int = 0
    
    @State private var WordsForQuiz: [String] = []
    // State variable to track the correctness of the answer
    @State private var isAnswerCorrect: Bool? = nil
    
    @State private var buttonsActive: [Bool] = []
    

    
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
            WordsForQuiz = createRandomWords()
            isAnswerCorrect = nil
            buttonsActive.removeAll()
            for _ in  0..<WordsForQuiz.count{
                buttonsActive.append(false)
            }
        }
        .onAppear {
            currentIndex = 0
            WordsForQuiz = createRandomWords()
            buttonsActive.removeAll()
            for _ in  0..<WordsForQuiz.count{
                buttonsActive.append(false)
            }
        }
    }
    
    //MARK: Logic of the Quizz evaluation
    
    func checkAnswer(UserText:String) {
        if currentIndex < diagram.labels.count {
            let correctAnswer = diagram.labels[currentIndex].text
            if UserText == correctAnswer {
                message = "Correct!"
                word = ""
                countCorrect += 1
                isAnswerCorrect = true
            } else {
                message = "Try again"
                isAnswerCorrect = false
            }
            if currentIndex == diagram.labels.count {
                message = "Quizz completed"
                diagram.score?.append(Float(countCorrect/diagram.labels.count))
                
            }
        } else {
            message = "Quizz completed"
//            diagram.score?.append(Float(countCorrect/diagram.labels.count))
        }
    }
    
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
    
    
    
    //MARK: Quizz View IPad
    //IPad on Horizontal Orientation View
    func iPadHorizontalView() -> some View{
        VStack{
            if let imageData = diagram.image,
               let uiImage = UIImage(data: imageData){
                GeometryReader { geometry in
                    ScrollView([.horizontal, .vertical], showsIndicators: true){
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(hex: "999999").opacity(0.50)
                                            , lineWidth: 2)
                            )
                            .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 4)
                            .padding()
                            .padding(.horizontal, 80.0)
                        //.offset(x: offset.width + dragState.width, y: offset.height + dragState.height)
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
            EasyQuizzView()
            
//            MediumQuizzView()
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
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(hex: "999999").opacity(0.50)
                                            , lineWidth: 2)
                            )
                            .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 4)
                            .padding()
                            .padding(.horizontal, 80.0)
                        //.offset(x: offset.width + dragState.width, y: offset.height + dragState.height)
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
            EasyQuizzView()
                .padding()
        }
    }
    
    func AlternatedQuizzView() -> some View{
        VStack{
            if let imageData = diagram.image,
               let uiImage = UIImage(data: imageData){
                GeometryReader { geometry in
                    ScrollView([.horizontal, .vertical], showsIndicators: true){
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(hex: "999999").opacity(0.50)
                                            , lineWidth: 2)
                            )
                            .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 4)
                            .padding()
                            .padding(.horizontal, 80.0)
                        //.offset(x: offset.width + dragState.width, y: offset.height + dragState.height)
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
            
            VStack{
                // Using LazyVGrid for a vertical grid layout
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                    let WordsForQuiz = createRandomWords()
                    ForEach(0..<4) { index in
                        Button(action: {
                            checkAnswer(UserText: WordsForQuiz[index])
                            
                        }) {
                            Text(WordsForQuiz[index])
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
                Text(message)
                    .padding()
                if (message == "Quizz completed"){
                    Button("RETURN"){
                        self.presentationMode.wrappedValue.dismiss()
                    }}
            }.frame(height: 300)
        }
    }
    func EasyQuizzView() -> some View {
        VStack {
            Text("What is this?")
                .font(.title3)
                .bold()
            
            // Using LazyVGrid for a vertical grid layout
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                ForEach(0..<WordsForQuiz.count, id: \.self) { index in
                    Button(action: {
                        checkAnswer(UserText: WordsForQuiz[index])
                        // Reset buttonsActive array and hide symbols
                        buttonsActive = Array(repeating: false, count: WordsForQuiz.count)
                        buttonsActive[index] = true // Activate selected button
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
            Button(action: {
                currentIndex += 1
            }){
                HStack{
                    
                    Text("Next")
                    Image(systemName: "greaterthan")
                }
                .padding()
            }
            
//            Text(message)
//                .padding()
//                .background(
//                    message == "Correct!" ? Color.green : (message == "Try again" ? Color.red : Color.clear)
//                )
//                .foregroundColor(.white)
//                .cornerRadius(8)
//                .padding(.horizontal)
//            
            if message == "Quizz completed" {
                Button("RETURN") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }.frame(width: 467)
    }

    
    func MediumQuizzView() -> some View{
        VStack{
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
                checkAnswer(UserText: word)
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
            if (message == "Quizz completed"){
                Button("RETURN"){
                    self.presentationMode.wrappedValue.dismiss()
                }}
        }.frame(width: 300)
    }
    
}


//#Preview {
//    QuizzView(diagram:Diagram(name:"",date:Date.now,labels: [DiagramLabel(text: "String", rectangle: CGRect(x: 0, y: 0, width: 100, height: 100)),DiagramLabel(text: "String", rectangle: CGRect(x: 0, y: 0, width: 100, height: 100))], image:UIImage(named: "ImagenPrueba")?.pngData()), currentIndex: .constant(1))
//}
