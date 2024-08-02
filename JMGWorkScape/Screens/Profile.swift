//
//  Profile.swift
//  JMGWorkScape
//
//  Created by Michael Guerrero on 8/2/24.
//

import Foundation
import SwiftUI

struct Profile: View {
    @State private var companyText: String = ""
    @State private var nameText: String = ""
    @State private var addressText: String = ""
    @State private var licenseText: String = ""

    var body: some View {
        VStack {
            HStack {
                Text("Name of Company: ")
                
                TextField("Enter Company", text: $companyText)
                    
            }
            .padding(.bottom, 20)
            .padding(.top, 30)
            .padding(.horizontal, 20)
            Group {
                HStack {
                    Text("Name of Contractor: ")
                    TextField("Enter Name", text: $nameText)
                }
                HStack {
                    Text("Billing Address")
                    TextField("Enter Address", text: $addressText)
                }
                HStack {
                    Text("License #")
                    TextField("Enter Number", text: $licenseText)
                }
            }
            .padding(.bottom, 20)
            .padding(.horizontal, 20)

            Spacer()
        }
        .navigationTitle("Contractor Profile")
    }
}
