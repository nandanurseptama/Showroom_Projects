//
//  ProductItem.swift
//  Showroom
//
//  Created by miracle on 06/07/23.
//

import SwiftUI

struct ProductItem: View {
    var productData : ProductData;
    
    init(productData: ProductData) {
        self.productData = productData
    }
    var body: some View {
        VStack(alignment: .leading){
            RemoteImageView(
                url: URL(string:productData.thumbnail)!,
                placeholder: {
                    Text("Loading")
                },
                image: {
                    $0
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            )
            Text(productData.name)
                .fontWeight(.bold)
                .font(.system(size: 18))
                .foregroundColor(.black)
        }
        .padding(.all, 16)
        .overlay{
            RoundedRectangle(cornerRadius: 8)
                .stroke(.gray, lineWidth: 0.9)
        }
    }
}

//struct ProductItem_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductItem(imageUrl: "https://raw.githubusercontent.com/nandanurseptama/Showroom_Projects/master/assets/images/honda_cb150r/honda_cb150r_1.png", productName: "Honda CB150R")
//    }
//}
