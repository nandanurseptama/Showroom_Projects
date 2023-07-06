//
//  RemoteImageView.swift
//  Showroom
//
//  Created by miracle on 06/07/23.
//

import SwiftUI

struct RemoteImageView<Placeholder: View, ConfiguredImage: View>: View {
    var url: URL
    private let placeholder: () -> Placeholder
    private let image: (Image) -> ConfiguredImage

    @ObservedObject var imageLoader: ImageLoaderService
    @State var imageData: UIImage?

    init(
        url: URL,
        @ViewBuilder placeholder: @escaping () -> Placeholder,
        @ViewBuilder image: @escaping (Image) -> ConfiguredImage
    ) {
        self.url = url
        self.placeholder = placeholder
        self.image = image
        self.imageLoader = ImageLoaderService(url: url)
    }

    @ViewBuilder private var imageContent: some View {
        if let data = imageData {
            image(Image(uiImage: data).resizable())
        } else {
            placeholder()
        }
    }

    var body: some View {
        imageContent
            .onReceive(imageLoader.$image) { imageData in
                self.imageData = imageData
            }
    }
}

class ImageLoaderService: ObservableObject {
    @Published var image = UIImage()

    convenience init(url: URL) {
        self.init()
        loadImage(for: url)
    }

    func loadImage(for url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data) ?? UIImage()
            }
        }
        task.resume()
    }
}
//struct RemoteImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        RemoteImageView(
//            url : URL(string:"https://raw.githubusercontent.com/nandanurseptama/Showroom_Projects/master/assets/images/honda_cb150r/honda_cb150r_1.png")!,
//            placeholder: {
//                Text("Loading")
//            },
//            image: {
//                $0.resizable().aspectRatio(1 ,contentMode: .fit)
//            }
//            
//        )
//    }
//}
