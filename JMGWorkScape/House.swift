//
//  House.swift
//  JMGWorkScape
//
//  Created by Christopher Rebollar on 7/18/24.
//

import Foundation
import SwiftData
import SwiftUI

//// Data Model
@Model
final class House: Identifiable {
    
    //
    // Class Attributes
    //
    
    var id: String
    private var name: String
    private var address: String
    private var frequency: String
    private var jobD: String
    private var imageData: Data?
    
    
    // Initialize
    init(_ name: String="", _ address: String="", _ job: String="", _ frequency: String="", _ imageData: Data? = nil) {
        self.id = UUID().uuidString
        self.name = name
        self.address = address
        self.frequency = frequency
        self.jobD = job
        self.imageData = imageData
    }

    // Exclusively used in EditHomeScreen
    func update(_ name: String="", _ address: String="", _ job: String="", _ frequency: String="", _ imageData: Data? = nil) {
        self.name = name
        self.address = address
        self.frequency = frequency
        self.jobD = job
        self.imageData = imageData
    }
    
    //
    // Class Methods
    //
    
    func getName() -> String {
        return self.name
    }
    
    func getAddress() -> String {
        return self.address
    }
    
    func getAddressKeyFormat() -> String {
        let modifiedAddress = self.address
            .lowercased() // Convert to lowercase
            .filter { $0.isLetter || $0.isNumber } // Keep only letters and numbers
        return modifiedAddress
    }
    
    func getJobD() -> String {
        return self.jobD
    }
    
    func getFrqSet() -> Set<String> {
        var components = self.frequency.components(separatedBy: ",")
        // Handle "and" separately, splitting components further
        components = components.flatMap { $0.components(separatedBy: "and") }
        // Trim whitespace and filter out invalid days
        let trimmedDays = components.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        return Set(trimmedDays)
    }
    
    func getFrqFormatted() -> String {
        return self.frequency
    }
    
    func getImg() -> Data? {
        return self.imageData
    }
}

class ChainDictionary{
    private var houses: [String: [House]] = [:]
    private var addresses: Set<String> = []
    
    init(_ housesArray: [House]){
        for house in housesArray{
            if houses[house.getName()] != nil {
                houses[house.getName()]?.append(house)
            }else{
                houses[house.getName()] = [house]
            }
            
            addresses.insert(house.getAddress())
        }
    }
    
    // overloading the [] operator
    subscript(houseName: String) -> [House]? {
        var housesToReturn: [House] = []

        if let housesForName = houses[houseName] {
            // Now housesForName is unwrapped and you can iterate over it
            for house in housesForName {
                housesToReturn.append(house)
            }
        }
        
        return housesToReturn
    }
    
    
    func getHouses(_ houseNameList : [String]) -> [House]?{
        var housesToReturn: [House] = []
        
        for name in houseNameList{
            if let housesFromName = houses[name]{
                for house in housesFromName{
                    housesToReturn.append(house)
                }
            }
        }
        
        return housesToReturn
    }
    
    func alreadyExists(_ houseAddress: String) -> Bool{
        return addresses.contains(houseAddress)
    }
}
