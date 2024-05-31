//
//  HomeView.swift
//  Macro
//
//  Created by yatziri on 13/05/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) var context
    @State private var selectedTopic: Topics? = Topics(label: "All Diagrams", iconName: "tray.fill")
    // Column Visibility describes what should be done with the Sidebar of the Nav Split View
    @State private var columnVisibility = NavigationSplitViewVisibility.detailOnly
    
    @State private var HideToolBarItem:Bool = false
    @State private var allDiagramsToggle:Bool = true
    @State private var AddTopic:Bool = false
    @State private var TopicName:String = ""
    @State private var selectedIcon: String = "lightbulb.fill"
    
    let iconCatalog: [String] = ["house.fill", "figure.arms.open", "tree.fill", "flask.fill", "syringe.fill", "mountain.2.fill", "globe.americas.fill","sun.dust.fill", "cloud.drizzle.fill", "lightbulb.fill" ]
        
    @Query(sort: \Topics.label) private var topics: [Topics]
    
    var body: some View {
        NavigationSplitView(columnVisibility:$columnVisibility) {
            if HideToolBarItem{
                ListSidebarView()
                    .toolbar(removing: .sidebarToggle)
            }
            else{
                ListSidebarView()
            }
        }
        detail: {
            DiagramListView(HideToolBarItem: $HideToolBarItem, columnVisibility: $columnVisibility, allDiagramsToggle: $allDiagramsToggle, selectedTopic: selectedTopic)
        }.sheet(isPresented: $AddTopic, content: {
            AddTopicView()
        })
    }
    
    
    func ListSidebarView() -> some View{
        List(selection: $selectedTopic) {
            Section{
                NavigationLink(
                    value: Topics(label: "All Diagrams", iconName: "tray.fill"),
                    label: {
                        HStack {
                            Image(systemName: "tray.fill")
                                .foregroundColor(allDiagramsToggle ? .white : Color.primaryColor1)
                            Text("All Diagrams")
                                .foregroundColor(allDiagramsToggle ? .white : .black)
                        }
                    }
                ).background(allDiagramsToggle ? Color.primaryColor1 : nil)
            }
            Section("Topics", content: {
                ForEach(topics, id: \.self) { topicM in
                    NavigationLink(
                        value: topicM,
                        label: {
                            HStack {
                                Image(systemName: "\(topicM.iconName)") // Assuming `localizedIcon` exists in `Topics`
                                    .foregroundColor(selectedTopic == topicM ? .white : .primaryColor1)
                                Text(topicM.label) // Assuming `label` exists in `Topics`
                            }
                        }
                    )
                    .swipeActions{
                        Button(role: .destructive) {
                            selectedTopic = Topics(label: "All Diagrams", iconName: "tray.fill")
                            withAnimation {
                                context.delete(topicM)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                    }
                }
            })
        }
        .onChange(of: selectedTopic, {
            if selectedTopic == Topics(label: "All Diagrams", iconName: "tray.fill"){
                allDiagramsToggle = true
            }else{
                allDiagramsToggle = false
            }
        })
        .navigationTitle("Title")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                Button(
                    action: {
                        AddTopic = true
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundStyle(Color.primaryColor1)
                    }
                )
            }
        }
    }
    
    func AddTopicView() -> some View{
        VStack {
            Spacer()
            Circle()
                .fill(Color.primaryColor2)
                .frame(width: 200, height: 200)
                .overlay(
                    Image(systemName: selectedIcon)
                        .resizable()
                        .padding()
                        .frame(width: 120, height: 120)
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color.white)
                        .padding()
                )
                .padding()
                .padding(.bottom, 20)
            List {
                Section("Write the name of the new topic") {
                    TextField("Topic", text: $TopicName)
                        .padding()
                }
                Section("Select the icon for the new topic"){
                    Picker("Icon", selection: $selectedIcon) {
                        ForEach(iconCatalog, id: \.self) { icon in
                            Image(systemName: icon).tag(icon)
                                .foregroundStyle(Color.primaryColor1)
                        }
                    }
                    .padding()
                }
            }.listStyle(.sidebar)
            
            Button(action: {
                context.insert(Topics(label: TopicName, iconName: selectedIcon))
                AddTopic = false
            }, label: {
                ZStack{
                    Rectangle()
                        .foregroundStyle(Color.primaryColor1)
                        .frame(maxWidth: .infinity )
                        .frame(height: 35)
                        .padding()
                        .shadow(color: Color.primaryColor2, radius: 10, x: 0, y: 5)
                        .cornerRadius(10)
                    Text("Save")
                        .font(.title)
                        .foregroundStyle(Color.white)
                }
            })
          
        }
    }
}
