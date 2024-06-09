//
//  AddNewTopicView.swift
//  Macro
//
//  Created by Vitor Kalil on 09/06/24.
//

import SwiftUI

struct AddNewTopicView: View {
        @Binding var selectedIcon: String
        @Binding var TopicName:String
        let iconCatalog: [String] = iconCatalogFunc()
    var body: some View{
        ScrollView{
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
                    let columns = UIDevice.current.userInterfaceIdiom == .phone ? Array(repeating: GridItem(.flexible(), spacing: 15), count: 4) : Array(repeating: GridItem(.flexible(), spacing: 15), count: 9)
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
                //            List {
                //                Section("Select the icon for the new topic"){
                //                    Picker("Icon", selection: $selectedIcon) {
                //                        ForEach(iconCatalog, id: \.self) { icon in
                //                            Image(systemName: icon).tag(icon)
                //                                .foregroundStyle(Color.primaryColor1)
                //                        }
                //                    }
                //                    .padding()
                //                }
                //            }.listStyle(.sidebar)
                
                //            Button(action: {
                //                context.insert(Topics(label: TopicName, iconName: selectedIcon))
                //                AddTopic = false
                //            }, label: {
                //                ZStack{
                //                    Rectangle()
                //                        .foregroundStyle(Color.primaryColor1)
                //                        .frame(maxWidth: .infinity )
                //                        .frame(height: 35)
                //                        .padding()
                //                        .shadow(color: Color.primaryColor2, radius: 10, x: 0, y: 5)
                //                        .cornerRadius(10)
                //                    Text("Save")
                //                        .font(.title)
                //                        .foregroundStyle(Color.white)
                //                }
                //            })
            }
            .background(Color(uiColor: .systemGray6))
        }.background(Color(uiColor: .systemGray6))}
    }


//#Preview {
//    AddNewTopicView()
//}
