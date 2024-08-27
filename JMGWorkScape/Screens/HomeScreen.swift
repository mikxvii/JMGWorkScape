//
//  HomeScreen.swift
//  JMGWorkScape
//
//  Created by Michael Guerrero and Christopher Rebollar-Ramirez on 7/13/24.
//

import SwiftUI
import Foundation
import SwiftData


struct Header: View {
    @State var goToProfile = false
    
    var body: some View{
        HStack(spacing: 190) {
            // Title of the Screen
            Text("Homes")
                .bold()
                .font(.largeTitle)
                .shadow(color: Color(red: 0.00, green: 0.00, blue: 0.00, opacity: 0.25), radius: 4, x: 0, y: 4)
                .foregroundColor(olive)
            
            Button(action: {
                goToProfile = true
            }, label: {
                Image(systemName: "person.crop.circle")
                    .font(.largeTitle)
                    .foregroundColor(olive)
            })
        }.navigationDestination(isPresented: $goToProfile) {
            ProfileScreen()
        }
    }
}

struct SearchBar: View{
    @Binding var searchText: String
    
    var body: some View{
        ZStack {
            TextField("'Calle Miramar..'", text: $searchText)
                .frame(maxWidth: 350, alignment: .topLeading)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Image(systemName: "magnifyingglass")
                .foregroundColor(olive)
                .offset(x: 145)
        }
    }
}

struct NoHouses: View{
    var body: some View{
        Spacer()
        Image(systemName: "tree")
            .foregroundColor(.gray)
            .font(.title)
        Text("No homes added")
            .foregroundColor(.gray)
        Spacer()
    }
    
}

struct HousesGrid: View {
    // Private Member Variables
    @Environment(\.modelContext) private var context
    @State private var houseToDelete: House?
    @State private var showAlert = false
    @State private var longPressDetected = false // State variable to track long press
    @State private var selectedHouse: House?
    @State private var goToDetails = false
    private let ITEMSPERPAGE = 6
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private func getItems(for page: Int, itemsPerPage: Int) -> [House] {
        let startIndex = (page - 1) * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, houses.count)
        return Array(houses[startIndex..<endIndex])
    }
    
    // Perameteres
    var housesDic: [String: House]
    var houses: [House]
    var pages: Int

    var body: some View {
        TabView {
            ForEach(1...pages, id: \.self) { page in
                VStack(){
                    LazyVGrid(columns: columns, alignment: .center, spacing: 30) {
                        let pageItems = getItems(for: page, itemsPerPage: ITEMSPERPAGE)
                        ForEach(pageItems, id: \.self) { item in
                            ZStack {
                                if let imageData = item.getImg(), let image = UIImage(data: imageData) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 150, height: 150)
                                        .cornerRadius(40)
                                        .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
                                } else {
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(gray)
                                        .frame(width: 150, height: 150)
                                        .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
                                }
                                VStack {
                                    Spacer()
                                    Text(item.getName())
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(darkOlive)
                                        .cornerRadius(15)
                                        .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
                                }
                                .padding(.bottom, 20)
                            }
                            .simultaneousGesture(
                                LongPressGesture().onEnded { _ in
                                    houseToDelete = item
                                    showAlert = true
                                    longPressDetected = true
                                }
                            )
                            .simultaneousGesture(
                                TapGesture().onEnded {
                                    longPressDetected = false
                                }
                            )
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Confirm Deletion"),
                                    message: Text("Are you sure you want to delete this house?"),
                                    primaryButton: .destructive(Text("Delete")) {
                                        if let houseToDelete = houseToDelete, let index = houses.firstIndex(of: houseToDelete) {
                                            context.delete(houses[index])
                                        }
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                        }
                    }

                    Spacer() // spacer to push items to the top when < 5 items in page
                }.padding(10) //  reduce the gap between columns
            }
            
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .navigationDestination(isPresented: $goToDetails) {
            if let selectedHouse = selectedHouse {
                HomeDetailsScreen(house: selectedHouse, houseDic: housesDic)
            }
        }
    }
}

struct MiddleView: View {
    // Private Member Variables
    @Environment(\.modelContext) private var context
    @Query private var houses: [House]
    private func pullItems(_ houseNames: [String]) -> [House] {
        // Use the house names to look up the corresponding House objects in the dictionary
        let houseObjects = houseNames.compactMap { housesDic[$0] }
        return houseObjects
    }
    
    // Parameters
    @Binding var searchText: String
    var searchTrie: Trie?
    var housesDic: [String: House]
    
    var body: some View{
        VStack(){
            // Page Calculation
            let itemsPerPage = 6
            
            if !houses.isEmpty{
                if searchText == "" {
                    let pages = Int(ceil(Double(houses.count) / Double(itemsPerPage)))
                    HousesGrid(housesDic: housesDic, houses:houses, pages: pages)
                }else{
                    let foundHouses = searchTrie?.wordsWithPrefix(searchText) ?? []
                    if !foundHouses.isEmpty {
                        let pages = Int(ceil(Double(foundHouses.count) / Double(itemsPerPage)))
                        let housesArray = pullItems(foundHouses)
                        HousesGrid(housesDic: housesDic, houses: housesArray, pages: pages)
                    }else{
                        Spacer()
                    }
                }
            }else{
                NoHouses()
            }
        }
    }
}

struct BottomButtons: View {
    // Private Member Variables
    @State private var goToRoute = false
    @State private var goToAdd = false
    
    // Parameters
    @State var houses: [House]
    var housesDic: [String: House]
    
    var body: some View{
        // Buttons for actions
        HStack(spacing: 115) {
            // Add a Home Button
            Button(action: {
                goToAdd = true
            }, label: {
                Image(systemName: "house.fill").foregroundColor(olive)
            }).sheet(isPresented: $goToAdd) {
                AddHomeScreen(housesDic: housesDic).navigationBarBackButtonHidden(true)
            }
            Button(action: {
                // navigate to route page
                goToRoute = true
            }, label: {
                Image(systemName: "map")
                    .foregroundColor(olive)
            }).navigationDestination(isPresented: $goToRoute) {
                RouteScreen(houses: houses, housesDic: housesDic)
            }
        }
        .padding(.bottom, 30.0)
        .font(.system(size: 40))
    }
}

struct HomeScreen: View {
    // Private Member Variables
    @State private var searchText = ""
    @State private var selectedHouse: House? = nil
    @Query private var houses: [House]
    @Environment(\.modelContext) private var context
    
    private var housesDic: [String: House] {
           Dictionary(uniqueKeysWithValues: houses.map { (key: $0.getName(), value: $0) })
    }
    
    private var searchTrie: Trie{
        Trie(words: houses.map { $0.getName() })
    }
    
    var body: some View {
        // Setting up for Screen switching
        GeometryReader { geo in
            NavigationStack {
                ZStack {
                    // HomeScreen background
                    Image("olive_screen")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    
                    VStack(spacing: 10) {
                        Header()
                        SearchBar(searchText: $searchText)
                        MiddleView(searchText: $searchText, searchTrie: searchTrie, housesDic: housesDic)
                        BottomButtons(houses: houses, housesDic: housesDic)
                    }
                }
            }.ignoresSafeArea(.all)
        }
    }
}
