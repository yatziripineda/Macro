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
    
    @Environment(\.presentationMode) var presentationMode // added this var to dismiss the view latter
    @State private var word: String = ""
    @Binding var currentIndex: Int
    @State private var message: String = ""
    @GestureState private var dragState = CGSize.zero
    @FocusState private var isTextFieldFocused: Bool // Created to hide keyboard after you send the guess on IPhoneVerticalView()

    
    var body: some View {
        if (UIDevice.current.userInterfaceIdiom == .phone){ // Checking if we are using an IPhone or IPad OBS: There is no Orientation filter yet
            //iPhoneVerticalView()
            AlternatedQuizzView()
        } else{
            iPadHorizontalView()
        }
    }
    
    //Yat's checkAnswer function with alt mode added by Vitor
    func checkAnswer() {
        if currentIndex < diagram.labels.count {
            let correctAnswer = diagram.labels[currentIndex].text
                if word == correctAnswer {
                    message = "Correct!"
                    currentIndex += 1
                    word = ""
                } else {
                    message = "Try again"
                }
            if currentIndex == diagram.labels.count { message = "Quizz completed" }
            } else {
                message = "Quizz completed"
                
            }
        }
    func checkAnswerAlt(buttonText:String) {
        if currentIndex < diagram.labels.count {
            let correctAnswer = diagram.labels[currentIndex].text
                if buttonText == correctAnswer {
                    message = "Correct!"
                    currentIndex += 1
                    word = ""
                } else {
                    message = "Try again"
                }
            if currentIndex == diagram.labels.count { message = "Quizz completed" }
            } else {
                message = "Quizz completed"
            }
        }
    func createRandomWords() -> [String] {
        var arrayWords = ["Presidente","Maynez","CHAMOY","Miguel","Yat","Fernanda","Vitor","Badge Out?"]
        arrayWords.shuffle()
        arrayWords.insert(diagram.labels[currentIndex].text, at: 0)
        var subArray = Array(arrayWords.prefix(4))
        subArray.shuffle()
        return subArray
    }
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
                if (message == "Quizz completed"){
                    Button("RETURN"){
                        self.presentationMode.wrappedValue.dismiss()
                    }}
            }.frame(width: 300)
        }
    }
    
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
            VStack{
                TextField("",
                          text: $word,
                          prompt: Text("What is this?")
                    .foregroundColor(.black.opacity(0.4))
                )
                .focused($isTextFieldFocused)
                .padding(12)
                .background(.gray.opacity(0.1))
                .cornerRadius(8)
                .foregroundColor(.primary)
                .padding()
                Button {
                    checkAnswer()
                    isTextFieldFocused = false // Hides keyboard after you click Check
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
            }.frame(height: 300)
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
                         var WordsForQuiz = createRandomWords()
                         ForEach(0..<4) { index in
                             Button(action: {
                                 checkAnswerAlt(buttonText:WordsForQuiz[index])
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
}

//#Preview {
//    QuizzView(diagram:Diagram(name:"",date:Date.now,labels: [DiagramLabel(text: "String", rectangle: CGRect(x: 0, y: 0, width: 100, height: 100)),DiagramLabel(text: "String", rectangle: CGRect(x: 0, y: 0, width: 100, height: 100))], image:UIImage(named: "ImagenPrueba")?.pngData()), currentIndex: .constant(1))
//}
