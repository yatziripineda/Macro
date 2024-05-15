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
    
    var filteredDiagram: [Diagram] {
        if searchText.isEmpty {
            return diagram
        } else {
            return diagram.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var topic: Topic?
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
    @GestureState private var dragState = CGSize.zero
    
    
    var body: some View {
        NavigationStack {
            if !recognizedData.isEmpty{
                BugSolveView(rectangles: $recognizedData, image: $image)
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
                        ContentUnavailableView("No Diagrams", image: "pencil.slash", description: Text("No views"))
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





struct DiagramButton: View {
    var diagram: Diagram
    
    var body: some View {
        ZStack {
            Image("ImagenPrueba")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 190, height: 163)
                .cornerRadius(20)
                .clipped()
            ZStack {
                VStack {
                    HStack {
                        Text(diagram.name)
                            .foregroundColor(.black)
                            .font(.footnote)
                            .bold()
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text("100%")
                            .font(.footnote)
                            .foregroundColor(Color(hex: "3C3C43").opacity(0.60))
                    }
                }
                .padding()
                .frame(width: 190)
                .background {
                    BottomRoundedRectangle(cornerRadius: 20)
                        .frame(width: 190, height: 55)
                        .foregroundColor(Color(hex: "F1F1F1"))
                }
            }.offset(y: 54)
        }
        .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 4)
    }
}

/*
#Preview {
    DiagramButton(diagram: Diagram(name: "Diagram", date: Date.now, labels: [("Hola",CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(1)))]))
}*/



struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(7)
                .padding(.horizontal, 45)
                .background(Color(.systemGray6))
                .cornerRadius(8)
//                .padding(.horizontal, 10)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 15)
                    }
                )
        }
    }
}
