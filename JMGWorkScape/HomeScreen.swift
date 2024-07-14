//
//  HomeScreen.swift
//  JMGWorkScape
//
//  Created by Michael Guerrero on 7/13/24.
//

import SwiftUI
import Foundation

struct HomeScreen: View {
    let olive = Color(red: 0.23, green: 0.28, blue: 0.20, opacity: 1.00)
    @State var searchText = ""
    var body: some View {
        VStack {
            HStack {
                Text("Homes")
                    .bold()
                    .font(.largeTitle)
                    .frame(maxWidth: 350, alignment: .topLeading)
                    .shadow(color: Color(red: 0.00, green: 0.00, blue: 0.00, opacity: 0.25), radius: 4, x: 0, y: 4)
                    .foregroundColor(olive)
                
            }
            TextField("'Calle Miramar..'", text: $searchText)
                .frame(maxWidth: 350, alignment: .topLeading)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button {
                
            } label: {
                Image(systemName: "house.fill")
            }   .foregroundColor(olive)
                .font(.largeTitle)
                .position(x: 50, y: 590)
            
            Button {
                
            } label: {
                Image(systemName: "plus.circle.fill")
            }   .foregroundColor(olive)
                .font(.largeTitle)
                .position(CGPoint(x: 50, y: 200))
            
            Image("olive_tree 1")
                .position(x: 250, y: 590)
            Image("olive_grass 1")
                .position(x: 190, y: 275)
        }
        .padding()
    }
}
