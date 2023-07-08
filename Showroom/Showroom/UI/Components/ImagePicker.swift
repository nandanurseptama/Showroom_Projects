import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var imageData: Data?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self){
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    let uiImage = image as? UIImage
                    guard let uiImage = uiImage else{
                        return;
                    }
                    if let pngData = uiImage.pngData(){
                        self.parent.imageData = pngData;
                        return;
                    }
                    if let jpegData = uiImage.jpegData(compressionQuality: 0.9){
                        self.parent.imageData = jpegData;
                    }
                    print("Picking image result nil")
                    return;
                }
            }
        }
    }
    
}
