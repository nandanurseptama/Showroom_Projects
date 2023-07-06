//
//  ProductItem.swift
//  Showroom
//
//  Created by miracle on 06/07/23.
//

import SwiftUI

struct ProductItem: View {
    var imagePath : String;
    var productName : String;
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 0.9)
                .shadow(radius: 1)
            VStack(alignment: .leading) {
                Image(imagePath)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                Text(productName)
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                Button{
                    print("");
                } label: {
                    Text("View more")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: 40)
                }
                .frame(maxHeight: 40)
                .frame(maxWidth:.infinity)
                .background{
                    Color(.systemBlue)
                }
                .cornerRadius(8)
                .padding(.bottom, 8)
            }
            .padding(.all, 8)
        }
    }
}

struct ProductItem_Previews: PreviewProvider {
    static var previews: some View {
        ProductItem(imagePath: "honda_cb150r_1", productName: "Honda CB150R")
    }
}
