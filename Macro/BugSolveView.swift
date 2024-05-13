//
//  BugSolveView.swift
//  Macro
//
//  Created by yatziri on 10/05/24.
//
import SwiftUI

struct BugSolveView: View {
    @Binding var rectangles: [(String, CGRect)]
    @State var str: [String]
    
    init(rectangles: Binding<[(String, CGRect)]>) {
           self._rectangles = rectangles
           self._str = State(initialValue: rectangles.wrappedValue.map { $0.0 })
       }
    
    var body: some View {
        VStack {
            ScrollView{
                ForEach(0..<rectangles.count, id: \.self) { index in
                    TextField("", text: $str[index])
                        .padding()
                        .border(Color.gray)
                        .padding()
                }
            }
            Button(
                action: {
                    for i in 0..<rectangles.count {
                                        rectangles[i] = (str[i], rectangles[i].1)
                                    }
                }) {
                    Text("Guardar")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
        }
    }
}


#Preview {
    BugSolveView(rectangles: .constant([("Exampl1", CGRect(x: 100, y: 50, width: 200, height: 50)),
                              ("Example2", CGRect(x: 50, y: 200, width: 250, height: 50))]))
}
