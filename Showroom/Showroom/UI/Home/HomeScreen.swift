//
//  HomeScreen.swift
//  Showroom
//
//  Created by miracle on 05/07/23.
//

import SwiftUI

struct HomeScreen: View {
    private var bounds = UIScreen.main.bounds
    
    private var gridItemLayout:  [GridItem]  {
        [
            GridItem(.flexible(minimum: 0, maximum: (bounds.width - 40) / 2), spacing: 16),
            GridItem(.flexible(minimum: 0, maximum: (bounds.width - 40) / 2),spacing: 16)
        ];
    }
    var body: some View {
        ScrollView{
            LazyVGrid(columns: gridItemLayout, alignment: .leading, spacing: 16){
                ProductItem(imagePath:"honda_cb150r_1", productName: "Honda CB 150R")
                    
                ProductItem(imagePath:"honda_cb150r_1", productName: "Honda CB 150R")
                ProductItem(imagePath:"honda_cb150r_1", productName: "Honda CB 150R")
                ProductItem(imagePath:"honda_cb150r_1", productName: "Honda CB 150R")
                ProductItem(imagePath:"honda_cb150r_1", productName: "Honda CB 150R")
                ProductItem(imagePath:"honda_cb150r_1", productName: "Honda CB 150R")
                ProductItem(imagePath:"honda_cb150r_1", productName: "Honda CB 150R")
                ProductItem(imagePath:"honda_cb150r_1", productName: "Honda CB 150R")
            }.padding(.horizontal, 16)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
