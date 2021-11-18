//
//  PhotoPicker.swift
//  MTest-MemoireUI
//
//  Created by 李昊堃 on 2021/11/4.
//


import SwiftUI
import PhotosUI

public struct PhotoPickerRepresentableView: UIViewControllerRepresentable {
    public init(selectedImage: Binding<[UIImage]>,multipleSelect: Bool = false) {
        self.multipleSelect = multipleSelect
        self._selectedImage = selectedImage
    }
    
        
    @Binding var selectedImage: [UIImage]
    var multipleSelect: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    public func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
     
        config.filter = .images
        config.selectionLimit = 1
        let controller = PHPickerViewController(configuration: config)
        
        controller.delegate = context.coordinator
        return controller
    }
    
    public func makeCoordinator() -> PhotoPickerRepresentableView.Coordinator {
        return Coordinator(self)
    }
    
    
    public func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }
    
    public  class Coordinator: PHPickerViewControllerDelegate {
        
        public  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            guard !results.isEmpty else {
                return
            }
            for result in results {
                let imageResult = result
                
                if imageResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    imageResult.itemProvider.loadObject(ofClass: UIImage.self) { (selectedImage, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                        
                          
                                if let selectedImage = (selectedImage  as? UIImage ){
                                    self.parent.selectedImage.append(selectedImage)
                                }
                                
                            
                        }
                    }
                }
            }
           
        }
        
        private let parent: PhotoPickerRepresentableView
        init(_ parent: PhotoPickerRepresentableView) {
            self.parent = parent
        }
    }
}

struct CustomPhotoPicker_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPickerRepresentableView(selectedImage: Binding.constant([]))
    }
}
