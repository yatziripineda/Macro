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
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 190))], spacing: 10) {
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
                        .padding()
                    }
                    .padding()
                }
                Spacer()
                    .navigationTitle(selectedTopic.label)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink {
                                ImageDiagramView()
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
