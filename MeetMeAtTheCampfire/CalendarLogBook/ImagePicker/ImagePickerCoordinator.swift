//
//  ImagePickerCoordinator.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 27.03.24.
//

import UIKit
import SwiftUI
import Foundation

struct ImagePicker: UIViewControllerRepresentable{
    
    @Binding var selectedImage: UIImage?
    @Binding var showImagePicker: Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    //Erstellt einen Coordinator um ihn oben im delegate context zu verwenden
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}

class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var parent: ImagePicker
    
    init(_ picker: ImagePicker) {
        self.parent = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //run code when user has selected
        print("Image selected")
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //able to get Image
            DispatchQueue.main.async {
                self.parent.selectedImage = image
            }
        }
        //Dismiss Picker
        parent.showImagePicker.toggle()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //run code when user canceled picker ui
        print("Image selection cancelled")
        //Dismiss Picker
        parent.showImagePicker.toggle()
    }
}
