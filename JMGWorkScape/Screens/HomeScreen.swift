//
//  HomeScreen.swift
//  JMGWorkScape
//
//  Created by Michael Guerrero on 7/13/24.
//

import SwiftUI
import Foundation

struct HomeScreen: View {
    // The olive Color that is used in this homescreen
    let olive = Color(red: 0.23, green: 0.28, blue: 0.20, opacity: 1.00)
    // Used for filtering of houses with TextField
    @State var searchText = ""
    var body: some View {
        NavigationView {
            ZStack {
                // HomeScreen background
                Image("olive_screen")
                    .resizable()
                    .ignoresSafeArea()
                    .aspectRatio(contentMode: .fill)
                
                VStack {
                    // Screen Title
                    Text("Homes")
                        .bold()
                        .font(.largeTitle)
                        .frame(maxWidth: 350, alignment: .topLeading)
                        .shadow(color: Color(red: 0.00, green: 0.00, blue: 0.00, opacity: 0.25), radius: 4, x: 0, y: 4)
                        .foregroundColor(olive)
                    
                    // Search field
                    ZStack {
                        TextField("'Calle Miramar..'", text: $searchText)
                            .frame(maxWidth: 350, alignment: .topLeading)

                        Image(systemName: "magnifyingglass")
                            .offset(x: 150)
                            .foregroundColor(olive)
                    }
                    Spacer()
                }
                .padding()
            }
            .padding()
        }
    }
}
