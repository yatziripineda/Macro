//
//  TopicDetail.swift
//  Macro
//
//  Created by yatziri on 13/05/24.
//
import SwiftUI
import SwiftData

enum Activities {
    case Option_Diagram1
    case Option_Diagram2
    var ActivitiesText: String{
        switch self {
        case .Option_Diagram1:
            return "Diagrams"
        case .Option_Diagram2:
            return "Diagrams1"
        }
    }
}



struct TopicDetail: View {
    @Query (sort: \Diagram.date)var diagram: [Diagram]
    @State private var activity: Activities = .Option_Diagram1
    @State private var showRectangle = true
    @State private var textPosition: CGFloat = 10
    @State private var searchText = ""
    @State private var currentIndex: Int = 0
    // Controls the visibility of the camera interface.
    @State private var showCamera = false
    // Stores the image captured by the camera.
    @State private var image: UIImage?
    // Receives information about the text recognized in the image.
    @State private var recognizedData: [(String, CGRect)] = []
    @State private var showQuizz = false
    /* Variables to move the image inside the scrollview */
    @State private var offset = CGSize.zero
    
    
    @Environment(\.modelContext) var context // CONTEXT ADDED FOR DEBBUGING (READ COMMENT BELOW)
    var filteredDiagram: [Diagram] {
        if searchText.isEmpty {
            return diagram
        } else {
            return diagram.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var topic: Topic?
    
    
    var body: some View {
        NavigationStack {
            if !recognizedData.isEmpty{
                WordReviewView(rectangles: $recognizedData, image: $image)
            }else{
                VStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Button(action: {
                                activity = .Option_Diagram1
                                textPosition = 10
                            }) {
                                Text("Diagrams")
                                    .font(.title3)
                                    .foregroundColor(activity == .Option_Diagram1 ? .black : .gray)
                            } .padding()
                            Button(action: {
                                activity = .Option_Diagram2
                                textPosition = 130
                            }) {
                                Text("Diagrams1")
                                    .font(.title3)
                                    .foregroundColor(activity == .Option_Diagram2 ? .black : .gray)
                            }
                            .padding()
                            Spacer()
                        }
                        
                        Rectangle()
                            .frame(width: 110, height: 5)
                            .foregroundColor(.black)
                            .padding(.horizontal, textPosition)
                            .padding(.bottom, -30.0)
                        Divider()
                    }
                    if diagram.isEmpty{
                        ContentUnavailableView {
                            Label("No Diagrams", systemImage: "pencil.slash")
                        } description: {
                            Text("No views")
                        }
                        //BUTTON ADDED FOR DEBBUGING - ELIMINATE AFTER DEBBUGING
                        //change yat: score: []
                        Button("CLICK"){
                            context.insert(Diagram(name:"",date:Date.now,labels: [DiagramLabel(text: "String", rectangle: CGRect(x: 50, y: 0, width: 100, height: 100)),DiagramLabel(text: "String2", rectangle: CGRect(x: 0, y: 0, width: 100, height: 100))], image:UIImage(named: "ImagenPrueba")?.pngData(), score: [], QuizDificulty: .easy))
                        }
                    }else{
                        ScrollView{
                            
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 190))], spacing: 10) {
                                ForEach(filteredDiagram, id: \.self) { diagram in
                                    NavigationLink {
                                        ImageDiagramView(diagram: diagram)
                                    } label: {
                                        DiagramButton(diagram: diagram)
                                            .id(diagram.id)
                                            .padding()
                                    }
                                    
                                }
                            }
                            .padding()
                        }
                        .padding()
                    }
                    Spacer()
                        .navigationTitle(topic?.localizednavigationTitle ?? "")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                NavigationLink {
                                    CameraView(image: $image, isShown: $showCamera)
                                    
                                    //                                .navigationBarBackButtonHidden(true)
                                } label: {
                                    Image(systemName: "doc.viewfinder")
                                        .foregroundColor(.blue)
                                }
                                //
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    
                                }) {
                                    Image(systemName: "square.and.pencil")
                                        .foregroundColor(.blue)
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    
                                }) {
                                    Text("Select")
                                        .foregroundColor(.blue)
                                    
                                    
                                    
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                SearchBar(text: $searchText)
                                    .padding()
                            }
                            
                        }
                    // Activates as soon as the user taps "use photo"
                        .onChange(of: image) { oldValue, newValue in
                            // If there is a new value for the image, we define it as "validImage"
                            if let validImage = newValue {
                                // We call a function to process the image
                                processImage(validImage) { recognizedData in
                                    // Here we could use Async/Await to ensure linear programming.
                                    DispatchQueue.main.async {
                                        if let data = recognizedData {
                                            /* We update the State variable to get the recognition data */
                                            self.recognizedData = data
                                        } else {
                                            print("No text was recognized.")
                                        }
                                    }
                                }
                            }
                        }
                }
            }
        }
    }
}



struct BottomRoundedRectangle: Shape {
    var cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
        path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    TopicDetail(topic: .all)
}
#Preview {
    HomeView()
}




