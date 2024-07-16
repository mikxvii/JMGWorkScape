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

// For color conversion from HEX

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

@Model
class House: Identifiable{
    var id: String;
    
    var name: String;
    var address: String;
    var frequency: String;
    //var image: UIImage?;
    var jobD: String;
    
    init(_ name: String, _ address: String, _ job: String, _ frequency: String){
        self.id = UUID().uuidString;
        self.name = name;
        self.address = address;
        self.frequency = frequency;
        //self.image = image;
        self.jobD = job;
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

//@Query private var items: [House]

func done(_ items: [String]){
    
}


