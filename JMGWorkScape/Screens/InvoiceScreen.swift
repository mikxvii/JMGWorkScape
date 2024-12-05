import Foundation
import SwiftUI


struct InvoiceScreen: View {
    
    //
    // Environment Variables
    //
    
    @EnvironmentObject var profileManager: ProfileManager
    
    //
    // State variables
    //
    
    @State private var selectedDate = Date()
    @State private var jobSite: String = ""
    @State private var jobDescription: String = ""
    @State private var total: Double = 0.0
    @State private var showingAlert = false
    @State private var alertMessage: String = "Please fill out all fields and ensure the total is greater than 0."
    @FocusState private var isFocused: Bool
    
    func validateFields() -> Bool {
        if jobSite.isEmpty || jobDescription.isEmpty || total <= 0 {
            return false
        }
        return true
    }
    
    // var profile: ProfilePackage
    var house: House
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background
                Image("azure_screen")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                ScrollView {
                    VStack {
                        // Title of Invoice
                        Text("\(house.getName())'s Invoice")
                            .bold()
                            .font(.largeTitle)
                            .shadow(color: Color(red: 0.00, green: 0.00, blue: 0.00, opacity: 0.25), radius: 4, x: 0, y: 4)
                            .foregroundColor(Color(red: 0.21, green: 0.51, blue: 0.87))
                        // Date Picker Section
                        HStack {
                            Spacer()
                            DatePicker("Today's Date: ", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .padding()
                           
                            Spacer()
                        }
                        // Job Site Frame
                        ZStack(alignment: .topLeading) {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 380, height: 150)
                                .background(Color(red: 0.57, green: 0.73, blue: 0.93))
                                .cornerRadius(6)
                            VStack (alignment: .leading) {
                                Text("Job Site")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(Color(red: 0.21, green: 0.51, blue: 0.87))
                                    .padding([.top, .leading], 10) // Adjust the padding as needed
                                TextField("Current Home Address", text: $jobSite)
                                    .frame(width: 360, height: 90) // Set the size of the TextField
                                    .background(Color.gray.opacity(0.2)) // Background color with opacity
                                    .cornerRadius(10) // Rounded corners
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2)) // Border
                                    .multilineTextAlignment(.center) // Text alignment inside the TextField
                                    .foregroundColor(.black) // Text color
                                    .font(.system(size: 18, weight: .medium, design: .default))
                                    .padding(.horizontal, 10)
                                    .focused($isFocused)
                            }
                            
                        }
                        .padding(.bottom, 20)
                        // Job Description Frame
                        ZStack(alignment: .topLeading) {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 380, height: 150)
                                .background(Color(red: 0.57, green: 0.73, blue: 0.93))
                                .cornerRadius(6)
                            VStack (alignment: .leading) {
                                Text("Job Description")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(Color(red: 0.21, green: 0.51, blue: 0.87))
                                    .padding([.top, .leading], 10) // Adjust the padding as needed
                                TextField("Job Description", text: $jobDescription)
                                    .frame(width: 360, height: 90) // Set the size of the TextField
                                    .background(Color.gray.opacity(0.2)) // Background color with opacity
                                    .cornerRadius(10) // Rounded corners
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2)) // Border
                                    .multilineTextAlignment(.center) // Text alignment inside the TextField
                                    .foregroundColor(.black) // Text color
                                    .font(.system(size: 18, weight: .medium, design: .default))
                                    .padding(.horizontal, 10)
                                    .focused($isFocused)
                            }
                            
                        }
                        .padding(.bottom, 20)
                        // Total Frame
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 380, height: 80)
                                .background(Color(red: 0.57, green: 0.73, blue: 0.93))
                                .cornerRadius(6)
                            HStack (alignment: .center) {
                                Text("Total")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(Color(red: 0.21, green: 0.51, blue: 0.87))
                                    .padding([.top, .leading], 10) // Adjust the padding as needed
                                Spacer()
                                    .frame(width: 200)
                                TextField("$000.00", value: $total, format: .number)
                                    .keyboardType(.decimalPad)
                                    .frame(width: 100, height: 60) // Set the size of the TextField
                                    .background(Color.gray.opacity(0.2)) // Background color with opacity
                                    .cornerRadius(10) // Rounded corners
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2)) // Border
                                    .multilineTextAlignment(.center) // Text alignment inside the TextField
                                    .foregroundColor(.black) // Text color
                                    .font(.system(size: 18, weight: .medium, design: .default))
                                    .padding(.horizontal, 10)
                                    .focused($isFocused)
                                    .toolbar {
                                        ToolbarItemGroup(placement: .keyboard) {
                                            Spacer() // Pushes the button to the right side
                                            Button("Done") {
                                                isFocused = false
                                            }
                                        }
                                    }
                            }
                        }
                        .padding(.bottom, 10)
                        .onTapGesture {
                            isFocused = false
                        }
                        ZStack {
                            Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 380, height: 170)
                            .background(Color(red: 0.57, green: 0.73, blue: 0.93))
                            .cornerRadius(6)
                            VStack {
                                HStack(alignment: .center) {
                                    let contractor = profileManager.profile.companyName + "\n" + profileManager.profile.contractorName + "\n" + profileManager.profile.billingAddress + "\nLic. #" + profileManager.profile.licenseNumber
                                    Text(contractor)
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.white)
                                        .frame(width: 360, height: 150)
                                        .multilineTextAlignment(.center) // Center-aligns the text
                                        .padding([.top, .leading], 10) // Adjust the padding as needed
                                }
                                Spacer()
                            }
                        }
                        Spacer()
                    }
                    .toolbar {
                        ToolbarItem {
                            if validateFields() {
                                ShareLink("Export PDF", item: render())
                            } else {
                                Button(action: {
                                    showingAlert = true
                                }, label: {
                                    HStack(alignment: .firstTextBaseline) {
                                        Text("Send")
                                        Image(systemName: "paperplane")
                                    }
                                })
                            }
                        }
                    }
                    .onAppear() {
                        jobSite = house.getAddress()
                        jobDescription = house.getJobD()
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(
                            title: Text("Incomplete Fields"),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
            }
        }
    }
    
    @MainActor func render() -> URL {
        // 1: Render Hello World with some modifiers
        let formattedDate = formatDate(selectedDate)

        let renderer = ImageRenderer(content:
            ZStack {
                // Background
                Image("azure_screen")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack {
                    Spacer()
                    // Title of Invoice
                    Text("\(house.getName())'s Invoice")
                        .bold()
                        .font(.largeTitle)
                        .shadow(color: Color(red: 0.00, green: 0.00, blue: 0.00, opacity: 0.25), radius: 4, x: 0, y: 4)
                        .foregroundColor(Color(red: 0.21, green: 0.51, blue: 0.87))
                    // Date Picker Section
                    HStack {
                        Spacer()
                        Text("Today's Date")
                            .foregroundColor(.black)
                        Spacer()
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 153, height: 34)
                                .cornerRadius(6)
                            Text(formattedDate)
                        }
                        Spacer()
                    }
                    // Job Site Frame
                    ZStack(alignment: .topLeading) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 380, height: 150)
                            .background(Color(red: 0.57, green: 0.73, blue: 0.93))
                            .cornerRadius(6)
                        VStack (alignment: .leading) {
                            Text("Job Site")
                                .font(.title2)
                                .bold()
                                .foregroundColor(Color(red: 0.21, green: 0.51, blue: 0.87))
                                .padding([.top, .leading], 10) // Adjust the padding as needed
                            Text(jobSite)
                                .frame(width: 360, height: 90) // Set the size of the TextField
                                .background(Color.gray.opacity(0.2)) // Background color with opacity
                                .cornerRadius(10) // Rounded corners
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2)) // Border
                                .multilineTextAlignment(.center) // Text alignment inside the TextField
                                .foregroundColor(.black) // Text color
                                .font(.system(size: 18, weight: .medium, design: .default))
                                .padding(.horizontal, 10)
                        }
                        
                    }
                    .padding(.bottom, 20)
                    // Job Description Frame
                    ZStack(alignment: .topLeading) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 380, height: 150)
                            .background(Color(red: 0.57, green: 0.73, blue: 0.93))
                            .cornerRadius(6)
                        VStack (alignment: .leading) {
                            Text("Job Description")
                                .font(.title2)
                                .bold()
                                .foregroundColor(Color(red: 0.21, green: 0.51, blue: 0.87))
                                .padding([.top, .leading], 10) // Adjust the padding as needed
                            Text(jobDescription)
                                .frame(width: 360, height: 90) // Set the size of the TextField
                                .background(Color.gray.opacity(0.2)) // Background color with opacity
                                .cornerRadius(10) // Rounded corners
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2)) // Border
                                .multilineTextAlignment(.center) // Text alignment inside the TextField
                                .foregroundColor(.black) // Text color
                                .font(.system(size: 18, weight: .medium, design: .default))
                                .padding(.horizontal, 10)
                        }
                        
                    }
                    .padding(.bottom, 20)
                    // Total Frame
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 380, height: 80)
                            .background(Color(red: 0.57, green: 0.73, blue: 0.93))
                            .cornerRadius(6)
                        HStack (alignment: .center) {
                            Text("Total")
                                .font(.title2)
                                .bold()
                                .foregroundColor(Color(red: 0.21, green: 0.51, blue: 0.87))
                                .padding([.top, .leading], 10) // Adjust the padding as needed
                            Spacer()
                                .frame(width: 200)
                            Text("$" + String(total))
                                .frame(width: 100, height: 60) // Set the size of the TextField
                                .background(Color.gray.opacity(0.2)) // Background color with opacity
                                .cornerRadius(10) // Rounded corners
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2)) // Border
                                .multilineTextAlignment(.center) // Text alignment inside the TextField
                                .foregroundColor(.black) // Text color
                                .font(.system(size: 18, weight: .medium, design: .default))
                                .padding(.horizontal, 10)

                        }
                    }
                    .padding(.bottom, 10)
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 380, height: 170)
                            .background(Color(red: 0.57, green: 0.73, blue: 0.93))
                            .cornerRadius(6)
                        VStack {
                            HStack(alignment: .center) {
                                let contractor = profileManager.profile.companyName + "\n" + profileManager.profile.contractorName + "\n" + profileManager.profile.billingAddress + "\nLic. #" + profileManager.profile.licenseNumber
                                Text(contractor)
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(width: 360, height: 150)
                                    .multilineTextAlignment(.center) // Center-aligns the text
                                    .padding([.top, .leading], 10) // Adjust the padding as needed
                            }
                        }
                    }
                    Spacer()
                }
            }
        )

        // 2: Save it to our documents directory
        let url = URL.documentsDirectory.appending(path: "\(house.getName())'s_Invoice_(\(formattedDate)).pdf")

        // 3: Start the rendering process
        renderer.render { size, context in
            // 4: Tell SwiftUI our PDF should be the same size as the views we're rendering
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)

            // 5: Create the CGContext for our PDF pages
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                return
            }

            // 6: Start a new PDF page
            pdf.beginPDFPage(nil)

            // 7: Render the SwiftUI view data onto the page
            context(pdf)

            // 8: End the page and close the file
            pdf.endPDFPage()
            pdf.closePDF()
        }

        return url
    }
}
