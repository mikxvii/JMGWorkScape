//
//  helper.swift
//  JMGWorkScape
//
//  Created by Christopher Rebollar on 7/13/24.
//
//  File where App Logic will be stored

import Foundation
import SwiftData
import SwiftUI
import PhotosUI
import UIKit


@MainActor
final class ImageModel: ObservableObject {
    
    @Published private(set) var selectedImage: Data? = nil
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }
    
    init() {
        return
    }
    
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self) {
                selectedImage = data
                return
            }
        }
    }
    func removeImage() {
        self.selectedImage = nil
        self.imageSelection = nil
    }

}

func home(){
    print("Go Home")
}

func route(){
    print("Add New")
}

func filter(){
    print("Filter")
}

func cancel(){
    print("cancel")
}

func search(){
    print("search")
}

