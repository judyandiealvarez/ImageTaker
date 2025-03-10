//
//  ImagePicker.swift
//  KeepStuff
//
//  Created by Judy Alvarez on 18/02/25.
//

import SwiftUI
import Foundation
import UIKit

public struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding
    var selectedImageData: Data?
    var sourceType: UIImagePickerController.SourceType

    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
      //  imagePicker.sourceType = .photoLibrary
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
      //  imagePicker.cameraViewTransform = CGAffineTransform(scaleX: 1, y: 1)
        return imagePicker
    }

    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Update the view controller if needed
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self) // selectedImageData: $selectedImageData)
    }

    public class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
                
        public init(_ parent: ImagePicker) {
            self.parent = parent
        }
        /*
        @Binding var selectedImageData: Data?

        init(selectedImageData: Binding<Data?>) {
            _selectedImageData = selectedImageData
        }
        */
        public func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImageData = image
               // selectedImageData = image
                    .fixImageOrientation()!
                    // .rotateClockwise(degrees: 90)
                    .pngData()
            }

            // picker.dismiss(animated: true, completion: nil)
            parent.presentationMode.wrappedValue.dismiss()
        }

        public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
