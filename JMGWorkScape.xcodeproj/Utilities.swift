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

// MARK: - House Test Data (Commented Out)

/*
 Test data for houses.
 Uncomment this array if needed for UI previews or testing.

 var houses: [House] = [
     House("Casa Bella", "123 Main St, Springfield", "Lawn Mowing", "Wenesday"),
     House("Villa Verde", "456 Oak St, Maplewood", "Garden Maintenance", "Tuesday, Thursday"),
     House("The White Cottage", "789 Pine St, Cedarville", "Pool Cleaning", "Friday"),
     House("Sunny Meadows", "101 Birch Rd, Oakwood", "Tree Trimming", "Monday, Saturday"),
     House("Hilltop Retreat", "202 Elm St, Ridgefield", "Patio Cleaning", "Sunday"),
     House("Ocean Breeze", "303 Maple Ave, Seaside", "Fence Repair", "Tuesday"),
     House("Mountain View", "404 Aspen Dr, Hillcrest", "Snow Removal", "Thursday"),
     House("Lakeside Manor", "505 Willow Ln, Lakeside", "Leaf Blowing", "Wednesday, Saturday"),
     House("Sunset Villa", "606 Cedar St, Highland", "Gutter Cleaning", "Friday"),
     House("Riverbend Estate", "707 River Rd, Riverdale", "Deck Staining", "Thursday"),
     House("Forest Glen", "808 Spruce St, Greenfield", "Roof Inspection", "Monday, Friday")]

*/

// MARK: - Custom UI Components

/// A custom button component used for frequency selection in `AddHomeScreen` and `EditHomeScreen`.
/// - `currFrequency`: The currently selected set of days (binding).
/// - `buttonColor`: The color of the button (changes dynamically based on selection).
/// - `day`: The label for the day being represented by the button.
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
