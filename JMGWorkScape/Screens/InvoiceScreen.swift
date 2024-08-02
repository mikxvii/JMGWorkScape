//
//  HomeDetailsScreen.swift
//  JMGWorkScape
//
//  Created by Michael Guerrero on 7/13/24.
//

import Foundation
import SwiftUI

struct InvoiceScreen: View {
    var house: House
    var body: some View {
        
        VStack {
            Text("\(house.getName())'s Invoice")
                .bold()
                .font(.largeTitle)
                .shadow(color: Color(red: 0.00, green: 0.00, blue: 0.00, opacity: 0.25), radius: 4, x: 0, y: 4)
                .foregroundColor(.mint)
            
            Spacer()
        }
    }
}
