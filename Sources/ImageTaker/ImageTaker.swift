//
//  ImagePicker.swift
//  KeepStuff
//
//  Created by Judy Alvarez on 18/02/25.
//

import SwiftUI
import ImageStorage

public struct ImageTaker: View {
    @Binding public var id: UUID?
    public var resizeWidth: Double = 60
    @State var selectedImage: Data? = nil
    @State var showImagePicker: Bool = false
    @State var imagePickerCaptureMode: Bool = false
    @State var showingDeleteAlert: Bool = false
        
    public var body: some View {
        VStack {
            
            Spacer()
                        
            if let img = selectedImage {
                SwiftUI.Image(uiImage: UIImage(data: img)!)
                    .resizable()
                    .scaledToFit()
            } else if selectedImage == nil,
                      let imageId = id {
                SwiftUI.Image(uiImage: UIImage(data: ImageStorage().get(imageId))!)
                    .resizable()
                    .scaledToFit()
            }
            else {
                HStack {
                    Spacer()
                    Text("No image selected")
                    Spacer()
                }
            }
                        
            HStack {
                Spacer()
                
                SwiftUI.Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .onTapGesture {
                        imagePickerCaptureMode = false
                        showImagePicker.toggle()
                    }
                    .accessibilityIdentifier("SelectImageOnEdit")
                    .padding()
                    .frame (width: 100, height: 100)
                // .background(.blue)
                // .buttonStyle(.plain)
                    .cornerRadius(10)
                
                Spacer()
                
                SwiftUI.Image(systemName: "camera")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .onTapGesture {
                        imagePickerCaptureMode = true
                        showImagePicker.toggle()
                    }
                    .accessibilityIdentifier("SelectImageOnEdit")
                    .padding()
                    .frame (width: 100, height: 100)
                // .background(.blue)
                // .buttonStyle(.plain)
                    .cornerRadius(10)
                
                Spacer()
                
                SwiftUI.Image(systemName: "trash")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .onTapGesture {
                        showingDeleteAlert.toggle()
                    }
                    .accessibilityIdentifier("SelectImageOnEdit")
                    .padding()
                    .frame (width: 100, height: 100)
                // .background(.blue)
                // .buttonStyle(.plain)
                    .cornerRadius(10)
                
                Spacer()

            }
            
        }
        .sheet(
            isPresented: $showImagePicker,
            onDismiss: {
                let imageStorage = ImageStorage()
                
                if let imageId = id  {
                    id = imageId
                    
                    do {
                        if let imageData = selectedImage {
                            
                            if let image = UIImage(data: imageData) {
                                let resizedImage = image.cropToSquare().resize(width: resizeWidth)
                                try imageStorage.remove(imageId)
                                try imageStorage.save(imageId, resizedImage.pngData() ?? Data())
                            }
                        }
                    }
                    catch let error {
                        fatalError(error.localizedDescription)
                    }
                }
                else {
                    let imageId = UUID()
                    id = imageId
                    
                    do {
                        if let imageData = selectedImage {
                            
                            if let image = UIImage(data: imageData) {
                                let resizedImage = image.cropToSquare().resize(width: resizeWidth)
                                try imageStorage.save(imageId, resizedImage.pngData() ?? Data())
                            }
                        }
                    }
                    catch let error {
                        fatalError(error.localizedDescription)
                    }
                }
            },
            content: {
                ImagePicker(
                    selectedImageData: $selectedImage,
                    sourceType: imagePickerCaptureMode ? .camera : .photoLibrary
                )
                .accessibilityIdentifier("ImagePicker")
            }
        )
        .confirmationDialog(
            Text("Are you sure you want to remove the image?"),
            isPresented: $showingDeleteAlert,
            titleVisibility: .visible
        ) {
            Button("Remove", role: .destructive) {
                withAnimation {
                    let imageStorage = ImageStorage()
                    if let imageId = id {
                        do {
                            try imageStorage.remove(imageId)
                            id = nil
                            selectedImage = nil
                            imagePickerCaptureMode.toggle()
                        }
                        catch let error {
                            fatalError(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    struct Preview: View {
        @State var id: UUID?
        var body: some View {
            ImageTaker(id: $id)
        }
    }

    return Preview()
}
