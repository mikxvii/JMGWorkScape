import Foundation
import SwiftUI

/// A view that displays detailed information about a specific house.
/// The screen includes the house's image, name, address, service frequency,
/// and provides options to create an invoice, get directions, or edit house details.
struct HomeDetailsScreen: View {
    
    //
    // Environment variables
    //
    
    /// Provides access to the current presentation mode (used for dismissing the view).
    @Environment(\.presentationMode) var presentationMode
    
    //
    // Parameters
    //
    
    /// The `House` object containing the details of the house to be displayed.
    var house: House
    
    /// An optional `ChainDictionary` to manage additional house data.
    var houseSearchManager: HouseSearchManager?
    
    //
    // State Variables
    //
    
    /// A Boolean state variable that triggers navigation to the Edit screen.
    @State var goToEdit: Bool = false
    
    /// A Boolean state variable that triggers navigation to the Invoice screen.
    @State var goToInvoice: Bool = false

    // Colors used in the UI.
    let gray = Color(red: 0, green: 0, blue: 0, opacity: 0.04)
    let darkOlive = Color(red: 0.19, green: 0.23, blue: 0.16, opacity: 1.00)

    var body: some View {
        // GeometryReader provides access to the size and position of the parent view.
        GeometryReader { geo in
            ZStack {
                // Background image for the screen.
                Image("stone_screen")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)

                // Scrollable content that displays the house details and action buttons.
                ScrollView(.vertical) {
                    VStack {
                        // Display the house image if available, otherwise show a placeholder.
                        if house.getImg() != nil {
                            if let image = UIImage(data: house.getImg()!) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: .infinity, maxHeight: 270)
                                    .cornerRadius(40)
                            }
                        } else {
                            Image(systemName: "photo.artframe")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(gray)
                                .frame(maxWidth: .infinity, maxHeight: 270)
                                .cornerRadius(40)
                        }

                        // Display the house owner's name.
                        Text(house.getName() + "'s Home")
                            .font(.largeTitle)
                            .bold()
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
                        
                        // Display the house address.
                        Text(house.getAddress())
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .frame(width: 289, height: 60)
                            .background(.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.bottom, 20)
                        
                        // Display the formatted service frequency.
                        Text("\(house.getFrqFormatted())'s")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .frame(width: 289, height: 60)
                            .background(darkOlive)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.bottom, 20)

                        // Button to create an invoice, navigates to the Invoice screen.
                        Button(action: {
                            goToInvoice = true
                        }, label: {
                            Text("Create Invoice")
                        })
                            .frame(width: 289, height: 50)
                            .foregroundColor(.white)
                            .background(.cyan)
                            .cornerRadius(10)
                            .padding(.bottom, 20)

                        // Button to open directions to the house address in Apple Maps.
                        Button(action: {
                            openMap(house.getAddress().replacingOccurrences(of: " ", with: ","))
                        }, label: {
                            Text("Take Me There")
                        })
                            .frame(width: 289, height: 50)
                            .foregroundColor(.white)
                            .background(.brown)
                            .cornerRadius(10)
                        
                        Spacer()
                    }
                    .ignoresSafeArea()
                    .toolbar {
                        // Toolbar item to navigate to the Edit screen.
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                goToEdit = true
                            }, label: {
                                Image(systemName: "pencil")
                            })
                        }
                    }
                }
            }
            // Navigate to the Edit screen when `goToEdit` is true.
            .sheet(isPresented: $goToEdit) {
                EditHomeScreen(houseSearchManager: houseSearchManager, house: house)
            }
            // Navigate to the Invoice screen when `goToInvoice` is true.
            .navigationDestination(isPresented: $goToInvoice) {
                InvoiceScreen(house: house)
            }
        }
    }
}
