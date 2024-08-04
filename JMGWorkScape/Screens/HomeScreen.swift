//
//  HomeScreen.swift
//  JMGWorkScape
//
//  Created by Michael Guerrero and Christopher Rebollar-Ramirez on 7/13/24.
//

import SwiftUI
import Foundation
import SwiftData

struct HomeScreen: View {
    // in CMYK format
    let olive = Color(red: 0.23, green: 0.28, blue: 0.20, opacity: 1.00)
    let gray = Color(red: 0, green: 0, blue: 0, opacity: 0.04)
    let darkOlive = Color(red: 0.19, green: 0.23, blue: 0.16, opacity: 1.00)
    
    @State var searchText = ""
    @State var goToDetails: Bool = false
    @State var goToAdd: Bool = false
    @State var goToRoute: Bool = false
    @State var goToProfile: Bool = false
    @State var selectedHouse: House? = nil
    @State private var showAlert = false
    @State private var houseToDelete: House?
    @State private var longPressDetected = false // State variable to track long press
    @Query private var houses: [House]
    @Environment(\.modelContext) private var context
    
    
    var housesDic: [String: House] {
           Dictionary(uniqueKeysWithValues: houses.map { (key: $0.getName(), value: $0) })
       }
       
   // Initialize the Trie
    @State private var searchTrie: Trie?
    
    // Function to get items for a specific page
    func getItems(for page: Int, itemsPerPage: Int) -> [House] {
        let startIndex = (page - 1) * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, houses.count)
        return Array(houses[startIndex..<endIndex])
    }
    
    func pullItems(_ houseNames: [String]) -> [House] {
        // Use the house names to look up the corresponding House objects in the dictionary
        let houseObjects = houseNames.compactMap { housesDic[$0] }
        return houseObjects
    }
    
    // These are used to help display the houses!
    private let numberColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
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
                        
                        ZStack {
                            TextField("'Calle Miramar..'", text: $searchText)
                                .frame(maxWidth: 350, alignment: .topLeading)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button(action: {
                                search()
                            }, label: {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(olive)
                            }).offset(x: 145)
                        }
                        
                        // Page Calculation
                        let itemsPerPage = 6
                        let pages = Int(ceil(Double(houses.count) / Double(itemsPerPage)))
                        
                        if searchText != ""{
                            let foundHouses = searchTrie?.wordsWithPrefix(searchText) ?? []
                            let itemsPerPage = 6
                            let pages = Int(ceil(Double(foundHouses.count) / Double(itemsPerPage)))
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 35) {
                                    ForEach(1..<pages + 1, id: \.self) { page in
                                        VStack {
                                            LazyVGrid(columns: numberColumns, spacing: 20) {
                                                let housesArray = pullItems(foundHouses)
                                                ForEach(housesArray, id: \.self) { item in
                                                    ZStack {
                                                        Button(action: {
                                                            if !longPressDetected {
                                                                selectedHouse = item
                                                                goToDetails = true
                                                            }
                                                        }, label: {
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
                                                        })
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
                                                    }
                                                }
                                            }
                                            .frame(width: 330)
                                            Spacer() // Need this spacer so when page isn't full of items, it starts on top
                                        }
                                    }
                                }
                                .scrollTargetLayout()
                                .padding(.horizontal, 30)
                            }
                            .padding(.top, 20)
                            .scrollClipDisabled()
                            .scrollTargetBehavior(.viewAligned)
                        }else{
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 35) {
                                    ForEach(1..<pages + 1, id: \.self) { page in
                                        let housesArray = getItems(for: page, itemsPerPage: itemsPerPage)
                                        VStack {
                                            LazyVGrid(columns: numberColumns, spacing: 20) {
                                                ForEach(housesArray, id: \.self) { item in
                                                    ZStack {
                                                        Button(action: {
                                                            if !longPressDetected {
                                                                selectedHouse = item
                                                                goToDetails = true
                                                            }
                                                        }, label: {
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
                                                        })
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
                                                    }
                                                }
                                            }
                                            .frame(width: 330)
                                            Spacer() // Need this spacer so when page isn't full of items, it starts on top
                                        }
                                    }
                                }
                                .scrollTargetLayout()
                                .padding(.horizontal, 30)
                            }
                            .padding(.top, 20)
                            .scrollClipDisabled()
                            .scrollTargetBehavior(.viewAligned)
                        }

                        if houses.isEmpty {
                            Spacer()
                            Image(systemName: "tree")
                                .foregroundColor(.gray)
                                .font(.title)
                            Text("No homes added")
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        // Buttons for actions
                        HStack(spacing: 115) {
                            // Add a Home Button
                            Button(action: {
                                goToAdd = true
                            }, label: {
                                Image(systemName: "house.fill").foregroundColor(olive)
                            })
                            
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
                            if let houseToDelete = houseToDelete, let index = houses.firstIndex(of: houseToDelete) {
                                context.delete(houses[index])
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                // trie stuff here
                .onAppear(){
                    // Initialize the Trie with house names
                    searchTrie = Trie()
                    for house in houses {
                        searchTrie?.insert(house.getName())
                    }
                    
    //                if houses.count != searchTrie?.getCount(){
    //                    for house in houses{
    //                        let isFound = searchTrie?.search(house.name) ?? false
    //                        if isFound{
    //                            searchTrie?.delete(house.name)
    //                        }
    //                    }
    //                }
                }
            }
            .ignoresSafeArea(.all)
        }
    }
}
