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
    @State private var selectedIcon: String = "figure"
    
    let iconCatalog: [String] = iconCatalogFunc()
    
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
        NavigationView(content: {
            AddNewTopicView(selectedIcon: $selectedIcon, TopicName: $TopicName)
                .navigationBarTitle("New Topic")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            context.insert(Topics(label: TopicName, iconName: selectedIcon))
                            self.AddTopic.toggle()
                        }.foregroundStyle(.primaryColor1)
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            self.AddTopic.toggle()
                        }.foregroundStyle(.primaryColor1)
                    }
                }.toolbarBackground(.bar, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        })
    })
    }
    
    func ListSidebarView() -> some View {
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
                                Image(systemName: "\(topicM.iconName)")
                                    .foregroundColor(selectedTopic == topicM ? .white : .primaryColor1)
                                Text(topicM.label)
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
        .navigationTitle("Topic list")
        .toolbar {
            /* This is the button to add a new Topic in the Topic list */
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    AddTopic = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(Color.primaryColor1)
                }
            }
        }
    }
    
    func AddTopicView() -> some View{
        VStack {
            VStack{
                Circle()
                    .fill(Color.primaryColor1)
                    .frame(width: 200, height: 200)
                    .overlay(
                        Image(systemName: selectedIcon)
                            .font(.system(size: 110))
                            .padding()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(Color.white)
                            .padding()
                    )
                    .padding(.top,20)
                    .padding()
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                TextField("Topic Name", text: $TopicName)
                    .padding()
                    .frame(height: 60)
                    .background(Color(uiColor: .systemGray5))
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                    .padding(40)
            }
            .background(.bar)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10))).padding(.top,20)
            .padding()
            .padding(.bottom,25)
            HStack{
                Text("Icon").foregroundStyle(.gray)
                Spacer()
            }
            .padding(.leading,25)
            Section() {
                // We create 9 columns with a repeated array for using them in the LazyVGrid.
                let columns = UIDevice.current.userInterfaceIdiom == .phone ? Array(repeating: GridItem(.flexible(), spacing: 15), count: 3) : Array(repeating: GridItem(.flexible(), spacing: 15), count: 9)
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(iconCatalog, id: \.self) { icon in
                        Button(action: {
                            self.selectedIcon = icon
                        }) {
                            VStack{
                                Image(systemName: icon)
                                    .font(.title)
                                    .frame(width: 60, height: 60, alignment: .center)
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(self.selectedIcon == icon ? .primaryColor2 : .gray)
                            }
                            .background(self.selectedIcon == icon ? .lightPurple : Color(uiColor: .systemGray6))
                            .clipShape(Circle())
                        }
                    }
                }.padding().background(.bar)
            }.clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                .padding([.bottom,.leading,.trailing],15)
            Spacer()
        }
        .background(Color(uiColor: .systemGray6))
    }
}

