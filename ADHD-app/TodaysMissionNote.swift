//
//  TodaysMissionNote.swift
//  ADHD-app
//
//  Created by Travis Lizio on 28/9/2025.
//

import SwiftUI
import UIKit
import SwiftData

struct TodaysMissionNote: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var missionNote: String = ""
    @State private var showEmojiPicker = false
    @State private var selectedEmoji: String?
    @FocusState private var isFocused: Bool
    @State private var showCamera = false
    @State private var capturedImage: UIImage?

    let missionTitle: String
    let missionImage: String
    
    init(
        missionTitle: String = "Default",
        missionImage: String = "imagesearch-rectangle"
    ) {
        self.missionTitle = missionTitle
        self.missionImage = missionImage
    }
    
    let emojiOptions = ["😆", "😅", "😐", "😞", "😡", "😳"]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Top bar
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title3.bold())
                            .foregroundColor(.gray)
                    }
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color(.systemGray6))
                            .cornerRadius(37)
                            .frame(height: 37)
                        Text("Capture something \(missionTitle) today!")
                            .font(.subheadline.bold())
                            .padding(.vertical, 8)
                            .foregroundColor(Color(.gray))
                    }
                    
                    Button("Save") {
                        saveCapture()
                        dismiss()
                    }
                    .font(.subheadline.bold())
                    .foregroundColor(.gray)
                }
                .padding()
                
                Text("41:12")
                    .font(.caption)
                    .padding(.bottom, 8)
                
                // Text field area
                VStack(alignment: .leading) {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $missionNote)
                            .focused($isFocused)
                            .padding(.horizontal)
                            .scrollContentBackground(.hidden)

                        if missionNote.isEmpty {
                            Text("Add a note or caption for your walk photo.")
                                .foregroundColor(Color(.placeholderText))
                            // Spaghetti Code :c
                                .padding(.horizontal, 22)
                                .padding(.vertical, 10)
                                .allowsHitTesting(false)  // taps still focus the editor
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                Spacer()
                
                // Toolbar above keyboard
                HStack(alignment: .bottom) {
                    Button(action: {
                        withAnimation(.spring()) {
                            showEmojiPicker.toggle()
                        }
                    }) {
                        if let selectedEmojiImage = selectedEmoji?.emojiToImage(){
                            Image(uiImage: selectedEmojiImage)
                        } else {
                            Image(systemName: "face.smiling")
                                .font(.system(size: 32).bold())
                                .foregroundStyle(Color(.systemGray2))
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showCamera = true
                    }) {
                        // Display captured image if available
                        if let image = capturedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(1, contentMode: .fill)
                                .scaledToFit()
                                .frame(width: 93, height: 93)
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .circular))
                        } else {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20, style: .circular)
                                    .frame(width: 93, height: 93)
                                    .foregroundStyle(Color(.systemGray5))
                                
                                Image(systemName: "camera")
                                    .font(.system(size: 48).bold())
                                    .foregroundStyle(Color(.systemGray2))
                                
                                Image(systemName: "plus.app.fill")
                                    .font(.system(size: 24))
                                    .offset(x: 24, y: 18)
                                    .foregroundStyle(Color(.gray))
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                .overlay(
                    Group {
                        if showEmojiPicker {
                            HStack(spacing: 12) {
                                ForEach(emojiOptions, id: \.self) { emoji in
                                    Text(emoji)
                                        .font(.system(size: 36))
                                        .onTapGesture {
                                            selectedEmoji = emoji
                                            withAnimation(.spring()) {
                                                showEmojiPicker = false
                                            }
                                        }
                                }
                            }
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                            .shadow(radius: 10)
                            .transition(.scale.combined(with: .opacity))
                            .offset(y: -20) // position above the toolbar
                        }
                    }
                )
            }
        }
        .onTapGesture {
            if showEmojiPicker {
                withAnimation(.spring()) {
                    showEmojiPicker = false
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isFocused = true
            }
        }
        .fullScreenCover(isPresented: $showCamera) {
            ImagePicker(image: $capturedImage)
                .ignoresSafeArea()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Save
    private func saveCapture() {
        // Convert optional image to data
        let imageData = capturedImage.flatMap { $0.jpegData(compressionQuality: 0.8) }

        // Use missionTitle as a default title if user didn't type a custom one
        let capture = Capture(
            title: missionTitle,
            mission: missionTitle,
            note: missionNote.isEmpty ? nil : missionNote,
            emoji: selectedEmoji,
            steps: (nil as Int?),
            imageData: imageData
        )
        modelContext.insert(capture)
    }
}

// MARK: - ImagePicker for Camera
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage.cropToSquare()
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

// MARK: - UIImage Extension for Square Cropping
extension UIImage {
    func cropToSquare() -> UIImage {
        let originalWidth = size.width
        let originalHeight = size.height
        let smallestDimension = min(originalWidth, originalHeight)
        
        let xOffset = (originalWidth - smallestDimension) / 2.0
        let yOffset = (originalHeight - smallestDimension) / 2.0
        
        let cropRect = CGRect(x: xOffset, y: yOffset, width: smallestDimension, height: smallestDimension)
        
        guard let cgImage = self.cgImage?.cropping(to: cropRect) else {
            return self
        }
        
        return UIImage(cgImage: cgImage, scale: self.scale, orientation: self.imageOrientation)
    }
}

#Preview {
    TodaysMissionNote()
}

extension String {
    func emojiToImage() -> UIImage? {
        let nsString = (self as NSString)
        let font = UIFont.systemFont(ofSize: 32) // you can change your font size here
        let stringAttributes = [NSAttributedString.Key.font: font]
        let imageSize = nsString.size(withAttributes: stringAttributes)
 
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0) //  begin image context
        UIColor.clear.set() // clear background
        UIRectFill(CGRect(origin: CGPoint(), size: imageSize)) // set rect size
        nsString.draw(at: CGPoint.zero, withAttributes: stringAttributes) // draw text within rect
        let image = UIGraphicsGetImageFromCurrentImageContext() // create image from context
        UIGraphicsEndImageContext() //  end image context
 
        return image
    }
}

