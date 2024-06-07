//
//  DiagramListView.swift
//  Macro
//
//  Created by yatziri on 13/05/24.
//

import SwiftUI
import SwiftData


/// MARK: Bug un Topic when go back from quizz
struct DiagramListView: View {
    
    @Query (sort: \Diagram.date)var diagram: [Diagram]
    
    @State private var NameTopicSelected:String  = (UserDefaults.standard.string(forKey: "NameTopic") ?? "All Diagrams")
    @State private var showRectangle = true
    @State private var textPosition: CGFloat = 10
    @Environment(\.modelContext) var context
    // state var for the searchbar
    @State private var searchText = ""
    // state var that track  the indec of the lable on the diagram
    @State private var currentIndex: Int = 0
    @State private var offset = CGSize.zero
    // to trach when the sidebar needs to hide
    
    @Binding var HideToolBarItem:Bool
    @Binding var columnVisibility: NavigationSplitViewVisibility
    @Binding var allDiagramsToggle:Bool
    
    //var that recive the actual topic to create the list of diagrams for that topic
    /*here is the bug problem*/
    var selectedTopic: Topics!
    
    // variable that change dhe list of diagram dippending on the searchbar
    var filteredDiagram: [Diagram] {
        if searchText.isEmpty {
            return diagram
        } else {
            return diagram.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Divider()
                if diagram.isEmpty{
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 190))], spacing: 10) {
                        AddDiagramButton()
                    }.padding(.top,55)
                } else {
                    ScrollView{
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 190))], spacing: 50) {
                            AddDiagramButton()
                            if selectedTopic.label == "All Diagrams"{
                                AllDiagramsView()
                            }else{
                                if ((selectedTopic.diagram) == nil){
                                    VStack(alignment: .center){
                                        Text("No Diagrams")
                                    }
                                }else{
                                    if (selectedTopic.diagram!.isEmpty){
                                    } else {
                                        FilterTopicsDiagramsView()
                                    }
                                }
                            }
                        }
                        .padding().padding(.top,55)
                    }
                    .padding()
                }
                Spacer()
                    .navigationTitle(selectedTopic.label)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button{
                                let newDiagram:Diagram = Diagram(name:"", date: Date.now,labels:tuppleToDiagramLabel(rectangles: [("Vena Cava", CGRect(x:139.19977660683972, y:129.28899152800165, width:127.60044860839841, height:24.31563377380367)), ("Pulmonary", CGRect(x:143.77434108177096, y:364.50804384521456, width:125.53271484375001, height:32.4392318725585)), ("valve", CGRect(x:172.22110319489008, y:395.81316566191157, width:66.27872467041016, height:26.40771102905278)), ("Right atrium", CGRect(x:136.59802385788237, y:576.221489137007, width:139.88534545898438, height:35.71021270751946)), ("Right ventricle", CGRect(x:124.98988074928268, y:753.7999474049209, width:165.46209716796878, height:34.170316696167)), ("Inferior vena", CGRect(x:132.1038754411764, y:857.6732408786424, width:148.87364196777344, height:29.16415596008305)), ("cava", CGRect(x:174.41526326705764, y:890.5153518845555, width:59.52993774414061, height:27.130998611450266)), ("Aorta", CGRect(x:1387.7679939238617, y:126.86428921511202, width:66.46401214599607, height:29.165039062500025)), ("Pulmonary artery", CGRect(x:1326.5813986294756, y:216.88510601969605, width:195.91859436035162, height:31.11489391326899)),("Pulmonary vein", CGRect(x:1333.6627926926603, y:367.7617019529725, width:181.7558135986328, height:30.646808624267706)), ("Left atrium", CGRect(x:1359.5452514736492, y:466.3373673628629, width:122.90950012207026, height:24.448668479919505)), ("Left ventricle", CGRect(x:1347.8255833662724, y:704.8765955819321, width:146.3488311767578, height:23.57446861267091)), ("Septum", CGRect(x:1376.0668025976402, y:850.7763460121542, width:87.50592803955075, height:28.813264846801786)), ("Descending", CGRect(x:1352.4194880988653, y:947.1173003956297, width:137.16102600097668, height:31.799442291259762)), ("aorta", CGRect(x:1387.772388444959, y:977.8898925353196, width:64.09475708007805, height:26.832981109619194))]), image: UIImage(named: "Example")?.pngData(), score: [], QuizDificulty: .easy, topic: nil)
                                context.insert(newDiagram)
                            } label: {
                                Image(systemName: "plus.square.dashed")
                                    .foregroundColor(Color.primaryColor1)
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                /* Missing action for "Select" button */
                            }) {
                                Text("Select")
                                    .foregroundColor(Color.primaryColor1)
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            SearchBar(text: $searchText)
                                .padding()
                        }
                    }
            }
        }
        .onAppear(){
            HideToolBarItem = false
        }
    }
    
    func AllDiagramsView() -> some View {
        ForEach(filteredDiagram, id: \.self) { diagram in
            NavigationLink {
                ImageDiagramView(diagram: diagram)
                    .onAppear(){
                        HideToolBarItem = true
                        columnVisibility = NavigationSplitViewVisibility.detailOnly
                    }
            } label: {
                DiagramButton(diagram: diagram)
                    .id(diagram.id)
                    .padding()
            }
        }
    }
    
    func FilterTopicsDiagramsView() -> some View {
        ForEach(filteredDiagram, id: \.self) { diagram in
            if(diagram.topic == nil){
            }
            else{
                if (diagram.topic! == selectedTopic) {
                    NavigationLink {
                        ImageDiagramView(diagram: diagram)
                            .onAppear(){
                                HideToolBarItem = true
                                columnVisibility = NavigationSplitViewVisibility.detailOnly
                            }
                    } label: {
                        DiagramButton(diagram: diagram)
                            .id(diagram.id)
                            .padding()
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

func getSelectedTopic(topicName:String,allTopicsList:[Topics]) -> Topics? {
    for topic in allTopicsList {
        if topic.label == topicName{
            return topic
        }
    }
    return nil
}
