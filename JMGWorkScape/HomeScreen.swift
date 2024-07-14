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
        
        ZStack{
            VStack{
                Image("olive_tree 1").border(Color.black)
                Image("olive_grass 1").border(Color.red)
            }.padding()

            VStack {
                HStack {
                    Spacer()
                    Text("Homes")
                        .bold()
                        .font(.largeTitle)
                        .frame(maxWidth: 350, alignment: .topLeading)
                        .shadow(color: Color(red: 0.00, green: 0.00, blue: 0.00, opacity: 0.25), radius: 4, x: 0, y: 4)
                        .foregroundColor(olive)
                    
                    Text("Label").bold()
                    Spacer()
                    
                }
                TextField("'Calle Miramar..'", text: $searchText)
                    .frame(maxWidth: 350, alignment: .topLeading)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer()
                HStack{
                    Spacer()
                    Button {
                    } label: {
                        Image(systemName: "house.fill")
                    }   .foregroundColor(olive)
                        .font(.largeTitle)
                    Spacer()
                    Button {
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }   .foregroundColor(olive)
                        .font(.largeTitle)
                    Spacer()

                }

                
            }
            .padding()
        }

    }
}
