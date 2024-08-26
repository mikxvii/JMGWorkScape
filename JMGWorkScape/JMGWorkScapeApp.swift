//
//  JMGWorkScapeApp.swift
//  JMGWorkScape
//
//  Created by Michael Guerrero and Christopher Rebollar-Ramirez on 7/13/24.
//

import SwiftUI

@main

struct JMGWorkScapeApp: App {
    @StateObject private var profileManager = ProfileManager()
    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environmentObject(profileManager)
        }
//        .modelContainer(for: House.self)
    }
}
