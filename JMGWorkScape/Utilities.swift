import Foundation
import SwiftData
import SwiftUI
import PhotosUI

// MARK: - Project Colors

/// Colors used in the project, defined in CMYK format:
/// - `olive`: A dark greenish color used as the primary theme color.
/// - `gray`: A very light gray, primarily used for subtle backgrounds.
/// - `darkOlive`: A deeper shade of olive for contrast.
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
            // Toggle button color and update selected frequency
            if (buttonColor == .cyan) {
                buttonColor = .gray
                currFrequency.remove(day)
            } else {
                buttonColor = .cyan
                currFrequency.insert(day)
            }
            print(currFrequency.formatted())  // Print updated frequency for debugging
        }, label: {
            Text(day)
                .frame(width: 120, height: 50)
                .foregroundColor(.white)
                .background(buttonColor)
                .cornerRadius(10)
        })
    }
}

// MARK: - Helper Functions

/// Opens Apple Maps with driving directions to the specified address.
/// - Parameters:
///   - `address`: The destination address.
///   - `startingAddress`: Optional starting address. Defaults to the current location.
func openMap(_ address: String, startingAddress: String? = nil) {
    var urlString = "https://maps.apple.com/?daddr=\(address)&directionsmode=driving"
    if let saddr = startingAddress {
        urlString += "&saddr=\(saddr)"
    }
    
    if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

/// Retrieves the current day of the week as a full string (e.g., "Monday").
/// - Returns: A string representing the current day of the week.
func getCurrentWeekday() -> String {
    Date().formatted(.dateTime.weekday(.wide))
}

/// Formats a `Date` object into a readable string in the format "MMMM d, yyyy".
/// - Parameter `date`: The date to format.
/// - Returns: A string in the format "Month Day, Year".
func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM d, yyyy"
    return dateFormatter.string(from: date)
}

/// Formats an address string to be used as a key by converting it to lowercase
/// and removing non-alphanumeric characters.
/// - Parameter `address`: The address to format.
/// - Returns: A lowercase, alphanumeric string suitable for key usage.
func addressKeyFormat(_ address: String) -> String {
    return address
        .lowercased()
        .filter { $0.isLetter || $0.isNumber }
}


