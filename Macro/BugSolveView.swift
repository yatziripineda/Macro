//
//  BugSolveView.swift
//  Macro
//
//  Created by yatziri on 10/05/24.
//
import SwiftUI
import SwiftData

struct BugSolveView: View {
    
    @Environment(\.modelContext) var context
    @Binding var image: UIImage?
    @Binding var rectangles: [(String, CGRect)]
    @State var str: [String] = [""]
//    var item: Diagram = Diagram(name: "", date: Date.now, labels: [DiagramLabel(text: "Hola", originX: 0, originY: 0, width: 1, height: 1)])

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
                    
                    print(rectangles)
                    
                        
                        var tupleList:[DiagramLabel] = []
                        for (s,r) in rectangles{
                            
                            print(s,r)
                            tupleList.append(DiagramLabel(text: s, rectangle: r))
                            
                        }
                    
                    
                    
                    
                    context.insert(Diagram(name:"", date: Date.now,labels:tupleList))
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

//private extension  BugSolveView {
//    
//    func save() {
//        item.name = ""
//        item.date = Date.now
//        item.labels = [rectangles.]
//        
////        modelContext.insert(item)
////        item.category = selectedCategory
////        selectedCategory?.items?.append(item)
////        item.acount = selectedAcount
////        selectedAcount?.items?.append(item)
//        
//    }
//}



//#Preview {
//    BugSolveView(rectangles: .constant([("Exampl1", CGRect(x: 100, y: 50, width: 200, height: 50)),
//                              ("Example2", CGRect(x: 50, y: 200, width: 250, height: 50))]))
//}
