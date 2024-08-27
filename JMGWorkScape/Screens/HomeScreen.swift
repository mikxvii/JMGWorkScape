//
//  HomeScreen.swift
//  JMGWorkScape
//
//  Created by Michael Guerrero and Christopher Rebollar-Ramirez on 7/13/24.
//

import SwiftUI
import Foundation
import SwiftData

var housesDic: [String: House] {
       Dictionary(uniqueKeysWithValues: houses.map { (key: $0.getName(), value: $0) })
}

struct Logo_Profile_Picture: View {
    @State var goToProfile: Bool
    
    var body: some View{
        HStack(spacing: 157) {
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

struct HousesGrid: View {
    var housesArray: [House]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var pages: Int
    let itemsPerPage = 6

    func getItems(for page: Int, itemsPerPage: Int) -> [House] {
        let startIndex = (page - 1) * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, housesArray.count)
        return Array(housesArray[startIndex..<endIndex])
    }
    
    var body: some View {
        TabView {
            ForEach(1...pages, id: \.self) { page in
                VStack(){
                    LazyVGrid(columns: columns, alignment: .center, spacing: 30) {
                        let pageItems = getItems(for: page, itemsPerPage: itemsPerPage)
                        ForEach(pageItems.indices, id: \.self) { index in
                            ZStack {
                                RoundedRectangle(cornerRadius: 40)
                                    .fill(Color.gray)
                                    .frame(width: 150, height: 150)
                                    .shadow(color: .black.opacity(0.7), radius: 10, x: 0, y: 7)
                                
                                VStack {
                                    Spacer()
                                    Text(pageItems[index].getName())
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(darkOlive) // Use your darkOlive color
                                        .cornerRadius(15)
                                }
                                .padding(.bottom, 20)
                            }
                        }
                    }
                    Spacer()
                }
            }
            
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    }
}

struct NoHouses: View{
    var body: some View{
        Image(systemName: "tree")
            .foregroundColor(.gray)
            .font(.title)
        Text("No homes added")
            .foregroundColor(.gray)
    }
}

struct MiddleView: View {
    @Binding var searchText: String
    @Binding var searchTrie: Trie?
    
    func pullItems(_ houseNames: [String]) -> [House] {
        // Use the house names to look up the corresponding House objects in the dictionary
        let houseObjects = houseNames.compactMap { housesDic[$0] }
        return houseObjects
    }
    
    var body: some View{
        VStack(){
            // Page Calculation
            let itemsPerPage = 6
            
            if !houses.isEmpty{
                if searchText == "" {
                    let pages = Int(ceil(Double(houses.count) / Double(itemsPerPage)))
                    HousesGrid(housesArray: houses, pages: pages)
                }else{
                    let foundHouses = searchTrie?.wordsWithPrefix(searchText) ?? []
                    if foundHouses.count != 0 {
                        let pages = Int(ceil(Double(foundHouses.count) / Double(itemsPerPage)))
                        let housesArray = pullItems(foundHouses)
                        HousesGrid(housesArray: housesArray, pages: pages)
                    }
                }
            }else{
                Spacer()
                NoHouses()
                Spacer()
            }

        }
    }
}

struct BottomButtons: View {
    @State var goToRoute: Bool
    @State var goToAdd: Bool
    
    var body: some View{
        // Buttons for actions
        HStack(spacing: 115) {
            // Add a Home Button
            Button(action: {
                goToAdd = true
            }, label: {
                Image(systemName: "house.fill").foregroundColor(olive)
            }).navigationDestination(isPresented: $goToAdd) {
                AddHomeScreen(housesDic:housesDic)
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
    @State var searchText = ""
    @State var goToDetails: Bool = false
    @State var goToAdd: Bool = false
    @State var goToRoute: Bool = false
    @State var goToProfile: Bool = false
    @State var selectedHouse: House? = nil
    @State private var showAlert = false
    @State private var houseToDelete: House?
    @State private var longPressDetected = false // State variable to track long press
//    @Query private var houses: [House]
    @Environment(\.modelContext) private var context
       
   // Initialize the Trie
    @State private var searchTrie: Trie?
    
    // Function to get items for a specific page
    func getItems(for page: Int, itemsPerPage: Int) -> [House] {
        let startIndex = (page - 1) * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, houses.count)
        return Array(houses[startIndex..<endIndex])
    }
    
    // These are used to help display the houses!
    
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
                        Logo_Profile_Picture(goToProfile: goToProfile)
                        SearchBar(searchText: $searchText)
                        MiddleView(searchText: $searchText, searchTrie: $searchTrie)
                        BottomButtons(goToRoute: goToRoute, goToAdd: goToAdd)


                        Spacer()

                    }
                    .padding()
                }
                .padding()
                .navigationDestination(isPresented: $goToDetails) {
                    if let selectedHouse = selectedHouse {
                        HomeDetailsScreen(house: selectedHouse, houseDic: housesDic)
                    }
                }
                .sheet(isPresented: $goToAdd) {
                    AddHomeScreen(housesDic: housesDic).navigationBarBackButtonHidden(true)
                }
                .navigationDestination(isPresented: $goToProfile) {
                    ProfileScreen()
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Confirm Deletion"),
                        message: Text("Are you sure you want to delete this house?"),
                        primaryButton: .destructive(Text("Delete")) {
//                            if let houseToDelete = houseToDelete, let index = houses.firstIndex(of: houseToDelete) {
//                                context.delete(houses[index])
//                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                // trie stuff here
                .onAppear(){
                    // Initialize the Trie with house names, will update when going back to homescreen
                    searchTrie = Trie()
                    for house in houses {
                        searchTrie?.insert(house.getName())
                    }
                }
            }
            .ignoresSafeArea(.all)
        }
    }
}
