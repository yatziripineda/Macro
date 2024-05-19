//
//  HomeView.swift
//  Macro
//
//  Created by yatziri on 13/05/24.
//
//
import SwiftUI

struct HomeView: View {
    @State private var selectedTopic: Topic? = .all
    // Column Visibility describes what should be done with the Sidebar of the Nav Split View
    @State private var columnVisibility = NavigationSplitViewVisibility.detailOnly
    var body: some View {
        NavigationSplitView(columnVisibility:$columnVisibility) {
            NavigationStack {
                VStack {
                    List(Topic.allCases, selection: $selectedTopic) { topic in
                        NavigationLink(
                            destination: TopicDetail(topic: topic)
                            ,
                            tag: topic,
                            selection: $selectedTopic
                        ) {
                            HStack {
                                Image(systemName: "\(topic.localizedIcon)")
                                    .foregroundColor(.blue)
                                Text(topic.localizedName)
                            }
                        }
                    }
                    .listStyle(SidebarListStyle())
                }
                .navigationTitle("Title")
            }
        }
    detail: {
        TopicDetail(topic: selectedTopic)
        }
    }
}





enum Topic: Int, Hashable, CaseIterable, Identifiable, Codable {
    case all
    case favorites

    var id: Int { rawValue }

    var localizedName: LocalizedStringKey {
        switch self {
        case .all:
            return "All"
        case .favorites:
            return "Favorites"
        }
    }
    var localizedIcon: String{
        switch self {
        case .all:
            return "tray"
        case .favorites:
            return "heart"
        }
    }
    var localizednavigationTitle: String{
        switch self {
        case .all:
            return "All Subjects"
        case .favorites:
            return "Favorites"
        }
    }
}


#Preview {
    HomeView()
}






