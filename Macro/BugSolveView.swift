//
//  BugSolveView.swift
//  Macro
//
//  Created by yatziri on 10/05/24.
//
import SwiftUI
import SwiftData

struct WordReviewView: View {
    
    @Environment(\.modelContext) var context
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode // added this var to dismiss the view latter
    @Binding var rectangles: [(String, CGRect)]
    @State var str: [String] = [""]
    
    
    init(rectangles: Binding<[(String, CGRect)]>,image:Binding<UIImage?>) {
        self._image = image
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
                    var tupleList:[DiagramLabel] = []
                    for (s,r) in rectangles{
                        print(s,r)
                        tupleList.append(DiagramLabel(text: s, rectangle: r))
                    }
                    let data = image?.pngData()
                    context.insert(Diagram(name:"", date: Date.now,labels:tupleList, image: data))
                    //rectangles = [] this is another way to dismiss the view (since it only shows if !.isEmpty
                    self.presentationMode.wrappedValue.dismiss()
                    
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
    WordReviewView(rectangles: .constant([("Exampl1", CGRect(x: 100, y: 50, width: 200, height: 50)),
                                        ("Example2", CGRect(x: 50, y: 200, width: 250, height: 50))]), image: .constant(UIImage(named: "ImagenPrueba")))
}
