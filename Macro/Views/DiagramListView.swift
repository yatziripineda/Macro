
//
//  TopicDetail.swift
//  Macro
//
//  Created by yatziri on 13/05/24.
//

import SwiftUI
import SwiftData


// MARK: Bug un Topic when go back from quizz

struct DiagramListView: View {
    @Query (sort: \Diagram.date)var diagram: [Diagram]
//    @EnvironmentObject var selectedTopic:SelectedTopic
//    @Environment(SelectedTopic.self) private var topic
    @State private var NameTopicSelected:String  = (UserDefaults.standard.string(forKey: "NameTopic") ?? "All Diagrams")
//    @State private var IconTopicSelected:String  = (UserDefaults.standard.string(forKey: "IconTopic") ?? "tray.fill")
    @State private var showRectangle = true
    @State private var textPosition: CGFloat = 10
    // state var for the searchbar
    @State private var searchText = ""
    // state var that track  the indec of the lable on the diagram
    @State private var currentIndex: Int = 0
    
    @State private var offset = CGSize.zero
    //ChangeYat:add  @State private var HideToolBarItem:Bool = false, @State private var columnVisibility = NavigationSplitViewVisibility.detailOnly
    // to trach when the sidebar needs to hide
    @Binding var HideToolBarItem:Bool
    @Binding var columnVisibility: NavigationSplitViewVisibility
    //var that recive the actual topic to create the list of diagrams for that topic
    /*here is the bug problem*/
    var topic: Topics!
    
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
                    ContentUnavailableView {
                        Label("No Diagrams", systemImage: "pencil.slash")
                    } description: {
                        Text("No views")
                    }
                }else{
                    ScrollView{
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 190))], spacing: 10) {
                            if true {
                                if topic.label == "All Diagrams"{
                                    AllDiagramsView()
                                }else{
                                    FilterTopicsDiagramsView()
                                }
                            }else{
                                AllDiagramsView()
                            }
                        }
                        .padding()
                    }
                    .padding()
                }
                Spacer()
                    .navigationTitle(topic.label)
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
        //ChangeYat: .onAppear()
        .onAppear(){
            HideToolBarItem = false
            
        }
    }
    func AllDiagramsView() -> some View{
        ForEach(filteredDiagram, id: \.self) { diagram in
            NavigationLink {
                ImageDiagramView(diagram: diagram)
                //ChangeYat: .onAppear()
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
    func FilterTopicsDiagramsView() -> some View{
        ForEach(filteredDiagram, id: \.self) { diagram in
            ForEach (diagram.topic, id: \.self){ oneTopic in
                if (oneTopic == topic) {
                    NavigationLink {
                        ImageDiagramView(diagram: diagram)
                        //ChangeYat: .onAppear()
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
    func saveData(information:Topics) {
        UserDefaults.standard.set(information, forKey: "Selectedtopic") // Save the logged-in status
//        UserDefaults.standard.set(username, forKey: "username")  Save the username
    }
    
    /// Function to load data from UserDefaults
//    func loadData() {
//        if let savedtopic = UserDefaults.standard.Topics(forKey: "Selectedtopic") {
//            username = savedUsername // If a username is saved, we load it
//        }
//        isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn") // Load the logged-in status
//    }
//    
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