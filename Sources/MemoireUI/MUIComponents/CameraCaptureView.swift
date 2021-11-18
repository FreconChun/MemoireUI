//
//  CameraCaptureView.swift
//  Memoire
//
//  Created by 李昊堃 on 2021/11/4.
//

import SwiftUI

public struct CaptureImageView : UIViewControllerRepresentable {
    
    /// MARK: - Properties
    @Binding var isShown: Bool
    @Binding var image: UIImage?
    
    public init(isShown: Binding<Bool>,image: Binding<UIImage?>){
        self._isShown = isShown
        self._image = image
    }
    
    public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
      @Binding var isCoordinatorShown: Bool
      @Binding var imageInCoordinator: UIImage?
      init(isShown: Binding<Bool>, image: Binding<UIImage?>) {
        _isCoordinatorShown = isShown
        _imageInCoordinator = image
      }
        public  func imagePickerController(_ picker: UIImagePickerController,
                    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
         imageInCoordinator = unwrapImage
         isCoordinatorShown = false
      }
        public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         isCoordinatorShown = false
      }
    }

    
    public func makeCoordinator() -> Coordinator {
      return Coordinator(isShown: $isShown, image: $image)
    }

    public func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<CaptureImageView>) {
        
    }
}

