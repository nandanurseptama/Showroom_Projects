//
//  ProductScreen.swift
//  Showroom
//
//  Created by miracle on 06/07/23.
//

import SwiftUI

struct ProductScreen: View {
    
    @StateObject var productDetail : ProductDetail = ProductDetail();
    @State var isHasFirstAppear = false;
    var productId : Int
    init(productId : Int) {
        self.productId = productId
    }
    
    var body: some View {
        NavigationView{
            builder
        }.task {
            if !isHasFirstAppear{
                productDetail.setProductId(productId: productId);
                productDetail.load()
                isHasFirstAppear = true
            }
        }
    }
    
    @ViewBuilder var builder : some View{
        if productDetail.fetchProductDetailState == FetchProductDetailState.Loading{
            Text("Loading")
        } else if productDetail.fetchProductDetailState == FetchProductDetailState.Loaded{
            productDetailBuilder
        } else if productDetail.fetchProductDetailState == FetchProductDetailState.NotFound{
            notFoundView
        } else if productDetail.fetchProductDetailState == FetchProductDetailState.Error{
            errorView
        } else{
            Text("Internal Error")
        }
    }
    @ViewBuilder var productDetailBuilder : some View{
        if let product = productDetail.productDetailData{
             VStack{
                 TabView{
                     ForEach(product.thumbnails, id: \.self){item in
                         RemoteImageView(
                            url: URL(string : item)!,
                            placeholder:{
                              Text("Loading")
                            },
                            image: {
                                $0
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fill)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                         )
                     }
                 }
                 .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                 .scrollDisabled(false)
                 .aspectRatio(1, contentMode: .fit)
                Text(product.name)
                    .fontWeight(.black)
            }
        } else{
            notFoundView
        }
    }
    var notFoundView : some View{
        Text("Not Found")
    }
    
    var errorView : some View{
        if let err = productDetail.productDetailErrorMessage{
            return Text(err)
        } else{
            return Text("Internal Error")
        }
    }
}

struct ProductScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProductScreen(productId: 1)
    }
}
