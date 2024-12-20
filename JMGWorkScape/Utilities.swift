import Foundation
import SwiftData
import SwiftUI
import PhotosUI


// in CMYK format
let olive = Color(red: 0.23, green: 0.28, blue: 0.20, opacity: 1.00)
let gray = Color(red: 0, green: 0, blue: 0, opacity: 0.04)
let darkOlive = Color(red: 0.19, green: 0.23, blue: 0.16, opacity: 1.00)

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
