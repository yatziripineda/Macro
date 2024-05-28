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
//    @Environment(SelectedTopic.self) private var selectedTopic
//    @EnvironmentObject var selectedTopic:SelectedTopic
//    @Environment(SelectedTopic.self) private var TopicSel
    @State private var selectedTopic: Topics! = Topics(label: "All Diagrams", iconName: "tray.fill")
    // Column Visibility describes what should be done with the Sidebar of the Nav Split View
    @State private var columnVisibility = NavigationSplitViewVisibility.detailOnly
    
    @State private var HideToolBarItem:Bool = false
    @State private var allDiagramsToggle:Bool = false
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
        DiagramListView(HideToolBarItem: $HideToolBarItem, columnVisibility: $columnVisibility, topic: selectedTopic)
    }.sheet(isPresented: $AddTopic, content: {
        AddTopicView()
    })
    }
    
    
    
    func ListSidebarView() -> some View{
        List(selection: $selectedTopic) {
            NavigationLink(destination: {
                DiagramListView(HideToolBarItem: $HideToolBarItem, columnVisibility: $columnVisibility, topic: Topics(label: "All Diagrams", iconName: "tray.fill"))
                //topic: Topics(label: "All Diagrams", iconName: "tray.fill")
                
                    .onAppear(){
                        allDiagramsToggle = true
                    }
            }, label: {
                HStack {
                    Image(systemName: "tray.fill")
                        .foregroundColor(allDiagramsToggle ? .white : Color.primaryColor1)
                    Text("All Diagrams")
                }
            })
            
            Section("Topics", content: {
                
                ForEach(topics, id: \.self) { topicM in
                    NavigationLink(
                        destination: DiagramListView(HideToolBarItem: $HideToolBarItem, columnVisibility: $columnVisibility,topic: selectedTopic),
                        tag: topicM,
                        selection: $selectedTopic
                    ) {
                        HStack {
                            Image(systemName: "\(topicM.iconName)") // Assuming `localizedIcon` exists in `Topics`
                                .foregroundColor(selectedTopic == topicM ? .white : .primaryColor1)
                            Text(topicM.label) // Assuming `label` exists in `Topics`
                        }
                    }
                    .swipeActions{
                        Button(role: .destructive) {
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
        .onChange(of: selectedTopic, { allDiagramsToggle=false})
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
//    private func deleteItem(item: Topic){
//        Button(role: .destructive) {
//            withAnimation {
//                context.delete(item)
//            }
//        } label: {
//            Label("Delete", systemImage: "trash.fill")
//        }
        
//    }
}
//
//UserDefaults example:
//
//import SwiftUI
//
//struct ContentView: View {
//    /* These 2 variables are going to be storaged in UserDefauls */
//    // Track whether the user is logged in
//    @State private var isUserLoggedIn: Bool = false
//    // Store the username
//    @State private var username: String = ""
//    
//    var body: some View {
//        VStack {
//            Toggle(isOn: $isUserLoggedIn) {
//                Text("User logged in“)
//            }
//            .padding()
//            
//            // TextField for entering the username
//            TextField(“User name”, text: $username)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//            
//            // Button that saves the data when tapped
//            Button(action: {
//                saveData() // Call the saveData function when the button is tapped
//            }) {
//                Text(“Save”)
//            }
//        }
//        .onAppear {
//            /* * We load the saved data when the view appears * */
//            loadData()
//        }
//    }
//    
//    /// Function to save data to UserDefaults
//    func saveData() {
//        UserDefaults.standard.set(isUserLoggedIn, forKey: "isUserLoggedIn") // Save the logged-in status
//        UserDefaults.standard.set(username, forKey: "username") // Save the username
//    }
//    
//    /// Function to load data from UserDefaults
//    func loadData() {
//        if let savedUsername = UserDefaults.standard.string(forKey: "username") {
//            username = savedUsername // If a username is saved, we load it
//        }
//        isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn") // Load the logged-in status
//    }
//}
