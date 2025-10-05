//
//  TodaysMissionNote.swift
//  ADHD-app
//
//  Created by Travis Lizio on 28/9/2025.
//

import SwiftUI

struct TodaysMissionNote: View {
    @State private var missionNote: String = ""
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
    
    var body: some View {
        VStack(spacing: 0) {
            // Top bar
            HStack {
                Button(action: {
                    // dismiss action
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
                    // save action
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
                    // custom emoji picker
                }) {
                    Image(systemName: "face.smiling")
                        .font(.system(size: 32).bold())
                        .foregroundStyle(Color(.systemGray2))
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
