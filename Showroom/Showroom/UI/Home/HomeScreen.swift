//
//  HomeScreen.swift
//  Showroom
//
//  Created by miracle on 05/07/23.
//

import SwiftUI

struct HomeScreen: View {
    
    @StateObject private var productsFeed : ProductsFeed = ProductsFeed()
    
    private var bounds = UIScreen.main.bounds
    
    private var gridItemLayout:  [GridItem]  {
        [
            GridItem(.flexible(minimum: 0, maximum: (bounds.width - 40) / 2), spacing: 16),
            GridItem(.flexible(minimum: 0, maximum: (bounds.width - 40) / 2),spacing: 16)
        ];
    }
    @ViewBuilder var builder : some View{
        if productsFeed.fetchProductsState == FetchProductsState.Loaded{
            productsList
        } else if productsFeed.fetchProductsState == FetchProductsState.Empty{
            Text("Products was empty")
        } else if productsFeed.fetchProductsState == FetchProductsState.Error{
            if let e = productsFeed.fetchProductsErrorMessage {
                Text(e)
            } else{
                Text("Internal Error")
            }
        }
        else{
            Text("Loading")
        }
    }
    var body: some View {
        builder.task{
            productsFeed.load()
        }
    }
    
    var productsList : some View{
        ScrollView{
            LazyVGrid(columns: gridItemLayout, alignment: .leading, spacing: 16){
                ForEach(productsFeed.products, id: \.self.id){
                    item in
                    ProductItem(imageUrl : item.thumbnail, productName: item.name)
                }
            }.padding(.all, 16)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
