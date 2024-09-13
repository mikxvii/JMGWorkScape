import Foundation
import SwiftUI

/// `RouteScreen` is a SwiftUI view that displays a list of houses scheduled for work on the current weekday.
/// The view allows users to see details of each house, remove houses from the list, and navigate to the house details screen.
struct RouteScreen: View {
    // The current weekday, determined by the `getCurrentWeekday()` function.
    var currentWeekday: String = getCurrentWeekday()
    
    // A list of all `House` objects to be displayed.
    var houses: [House]
    
    // An optional dictionary (`ChainDictionary`) to manage and retrieve houses more efficiently.
    var houseSearchManager: HouseSearchManager?
    
    // State variables to manage the lists of houses being edited, stopped, and remaining.
    @State var editHouses: [House] = []
    @State var stopHouses: [House] = []
    @State var remainingHouses: [House] = []
    
    // An array representing the days of the week during which work is scheduled.
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    
    // A custom color used for styling elements in the view.
    let darkOlive = Color(red: 0.19, green: 0.23, blue: 0.16, opacity: 1.00)
    
    // State variables to control navigation and track the currently selected house.
    @State private var goToDetails = false
    @State private var goToAddStop = false
    @State private var selectedHouse: House?
       
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background image that fills the entire screen.
                Image("bronze_screen")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                
                // Display the list of houses only if today is a workday.
                if daysOfWeek.contains(currentWeekday) {
                    VStack {
                        
                        // A map icon at the top of the list.
                        Image(systemName: "map.circle")
                            .font(.title2)
                            .foregroundColor(.brown)
                        
                        // The list of houses to be displayed.
                        List {
                            ForEach(editHouses, id: \.self) { house in
                                HStack {
                                    Spacer()
                                    ZStack {
                                        // Display the house's image if available; otherwise, show a placeholder.
                                        if let imageData = house.getImg(), let image = UIImage(data: imageData) {
                                            Image(uiImage: image)
                                                .frame(width: 360, height: 70)
                                                .cornerRadius(10)
                                                .padding(.bottom, 20)
                                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                                    // Swipe action to delete the house from the list.
                                                    Button(role: .destructive) {
                                                        if let index = editHouses.firstIndex(of: house) {
                                                            editHouses.remove(at: index)
                                                        }
                                                    } label: {
                                                        Label("Delete", systemImage: "trash")
                                                    }
                                                }
                                                .multilineTextAlignment(.center)
                                                .onTapGesture {
                                                    goToDetails = true
                                                    selectedHouse = house
                                                }
                                        } else {
                                            // Placeholder view when no image is available.
                                            RoundedRectangle(cornerRadius: 10)
                                                .frame(width: 360, height: 70)
                                                .cornerRadius(10)
                                                .padding(.bottom, 20)
                                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                                    // Swipe action to delete the house from the list.
                                                    Button(role: .destructive) {
                                                        if let index = editHouses.firstIndex(of: house) {
                                                            editHouses.remove(at: index)
                                                        }
                                                    } label: {
                                                        Label("Delete", systemImage: "trash")
                                                    }
                                                }
                                                .multilineTextAlignment(.center)
                                                .onTapGesture {
                                                    goToDetails = true
                                                    selectedHouse = house
                                                }
                                        }
                                        // House name and address displayed as text over the image or placeholder.
                                        Text("\(house.getName()): \(house.getAddress())")
                                            .foregroundStyle(.white)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(darkOlive)
                                            .cornerRadius(15)
                                            .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
                                    }
                                    Spacer()
                                }
                            }

                        }
                        .listStyle(.inset)
                        .frame(height: 640)
                        Spacer()
                    }
                } else {
                    // Display a message when today is not a workday.
                    VStack {
                        Spacer()
                        Image(systemName: "tree")
                            .foregroundColor(.gray)
                            .font(.title)
                        Text("No work today :)")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    // Display the current weekday as the title in the toolbar.
                    if daysOfWeek.contains(currentWeekday) {
                        Text("\(currentWeekday) Route")
                            .bold()
                            .font(.largeTitle)
                            .shadow(color: Color(red: 0.00, green: 0.00, blue: 0.00, opacity: 0.25), radius: 4, x: 0, y: 4)
                            .foregroundColor(.brown)
                    } else {
                        Text("\(currentWeekday)")
                            .bold()
                            .font(.largeTitle)
                            .shadow(color: Color(red: 0.00, green: 0.00, blue: 0.00, opacity: 0.25), radius: 4, x: 0, y: 4)
                            .foregroundColor(.brown)
                    }
                }
            }
            // Navigate to the `HomeDetailsScreen` when a house is selected.
            .navigationDestination(isPresented: $goToDetails) {
                if let selectedHouse = selectedHouse {
                    HomeDetailsScreen(house: selectedHouse, houseSearchManager: houseSearchManager)
                }
            }
            // Filter and assign the houses to the appropriate lists when the view appears.
            .onAppear {
                editHouses = houses.filter { $0.getFrqSet().contains(currentWeekday) }
                remainingHouses = houses.filter { !$0.getFrqSet().contains(currentWeekday) }

            }
        }
    }
}
