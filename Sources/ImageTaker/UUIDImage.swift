//
//  UUIDImage.swift
//  KeepStuff
//
//  Created by Judy Alvarez on 18/02/25.
//

import SwiftUI
import Foundation
import UIKit

public struct UUIDImage: View {
    let imageId: UUID?
    let imageSize: Int

    public var body: some View {
        VStack {
            let fileManager = FileManager.default
            let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

            if imageId != nil {
                let filePath = documentsDirectory.appendingPathComponent("images/\(imageId!)_\(imageSize).png")

                if fileManager.fileExists(atPath: filePath.path) {
                    if let imageData = try? Data(contentsOf: filePath),
                        let image = UIImage(data: imageData) {
                        SwiftUI.Image(uiImage: image)
                             .resizable()
                             .frame(width: CGFloat(imageSize), height: CGFloat(imageSize))
                        }
                }
            }
        }
    }
}



