//
//  HomeDetailsScreen.swift
//  JMGWorkScape
//
//  Created by Michael Guerrero on 7/13/24.
//

import Foundation
import SwiftUI

struct AddHomeScreen: View {
    @State var emptyArray = ["", "", ""]
    
    var body: some View {
        VStack(spacing: 30){
            HStack(spacing: 170){
                Button(action: {
                    cancel()
                }, label: {
                    Text("Cancel")
                        .bold()
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        .padding(10)
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                })
                
                Button(action: {
                    done()
                }, label: {
                    Text("Done")
                        .bold()
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                })
            }
            
            Image(systemName: "house.fill")
                .font(.system(size:  50))
                .padding(.vertical, 75.0)
                .padding(.horizontal, 150)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
            TextField("Name", text: $emptyArray[0])
                                .frame(maxWidth: 350, alignment: .topLeading)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            
            TextField("Address", text: $emptyArray[1])
                                .frame(maxWidth: 350, alignment: .topLeading)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Frequency", text: $emptyArray[2])
                                .frame(maxWidth: 350, alignment: .topLeading)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
            
        }
        Spacer()


    }
}
