//
//  helper.swift
//  JMGWorkScape
//
//  Created by Christopher Rebollar on 7/13/24.
//
//  

import Foundation
import SwiftData
import SwiftUI
import PhotosUI

// Colors needed for this project
// in CMYK format
let olive = Color(red: 0.23, green: 0.28, blue: 0.20, opacity: 1.00)
let gray = Color(red: 0, green: 0, blue: 0, opacity: 0.04)
let darkOlive = Color(red: 0.19, green: 0.23, blue: 0.16, opacity: 1.00)


// houses for testing 11 houses
//var houses: [House] = [
//    House("Casa Bella", "123 Main St, Springfield", "Lawn Mowing", "Wenesday"),
//    House("Villa Verde", "456 Oak St, Maplewood", "Garden Maintenance", "Tuesday, Thursday"),
//    House("The White Cottage", "789 Pine St, Cedarville", "Pool Cleaning", "Friday"),
//    House("Sunny Meadows", "101 Birch Rd, Oakwood", "Tree Trimming", "Monday, Saturday"),
//    House("Hilltop Retreat", "202 Elm St, Ridgefield", "Patio Cleaning", "Sunday"),
//    House("Ocean Breeze", "303 Maple Ave, Seaside", "Fence Repair", "Tuesday"),
//    House("Mountain View", "404 Aspen Dr, Hillcrest", "Snow Removal", "Thursday"),
//    House("Lakeside Manor", "505 Willow Ln, Lakeside", "Leaf Blowing", "Wednesday, Saturday"),
//    House("Sunset Villa", "606 Cedar St, Highland", "Gutter Cleaning", "Friday"),
//    House("Riverbend Estate", "707 River Rd, Riverdale", "Deck Staining", "Thursday"),
//    House("Forest Glen", "808 Spruce St, Greenfield", "Roof Inspection", "Monday, Friday")
//]



//
// Custom Button element exclusively used for Frequency selection (AddHomeScreen, EditHomeScreen)
//
struct DayButton: View {
    @Binding var currFrequency: Set<String>
    @State var buttonColor: Color
    var day: String
    
    var body: some View {
        Button(action: {
            if (buttonColor == .cyan) {
                buttonColor = .gray
                currFrequency.remove(day)
                print(currFrequency.formatted())
            } else {
                buttonColor = .cyan
                currFrequency.insert(day)
                print(currFrequency.formatted())
            }
        }, label: {
            Text(day)
                .frame(width: 120, height: 50)
                .foregroundColor(.white)
                .background(buttonColor)
                .cornerRadius(10)
        })
    }
}


//
// Helper Functions
//

func openMap(_ address: String, startingAddress: String? = nil) {
//    UIApplication.shared.open(URL(string: "http://maps.apple.com/?address=\(address)")! as URL)
    var urlString = "https://maps.apple.com/?daddr=\(address)&directionsmode=driving"
    if let saddr = startingAddress {
        urlString += "&saddr=\(saddr)"
    }
    
    if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

func getCurrentWeekday() -> String {
    Date().formatted(.dateTime.weekday(.wide))
}

func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM d, yyyy" // Set the desired format
    return dateFormatter.string(from: date)
}
