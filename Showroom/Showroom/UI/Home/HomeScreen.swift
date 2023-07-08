//
//  HomeScreen.swift
//  Showroom
//
//  Created by miracle on 05/07/23.
//

import SwiftUI

struct HomeScreen: View {
    @StateObject private var productsFeed : ProductsFeed = ProductsFeed()
    
    @EnvironmentObject private var navigationManager : NavigationManager;
    @EnvironmentObject private var shoppingCart : ShoppingCart;
    
    @State var isFirstAppear : Bool = false;
    @State private var linkActive = false
    @State private var selectedProductId : Int?;
    
    private var bounds = UIScreen.main.bounds
    
    private var gridItemLayout:  [GridItem]  {
        [
            GridItem(.flexible(minimum: 0, maximum: (bounds.width - 40) / 2), spacing: 16),
            GridItem(.flexible(minimum: 0, maximum: (bounds.width - 40) / 2),spacing: 16)
        ];
    }
    var builder : some View{
        Group{
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
    }
    var body: some View {
        builder.task{
            if !isFirstAppear{
                await self.productsFeed.load()
                isFirstAppear = true;
            }
        }
        .onChange(of: self.navigationManager.activeTabIndex){newValue in
            linkActive = false;
        }
        
    }
    func selectedProductIdIsNull() -> Bool{
        if let _ = self.selectedProductId{
            return false;
        }
        return true;
    }
    
    var productsList : some View{
        let isNavigationActive = Binding<Bool>(
            get: { self.linkActive && !self.selectedProductIdIsNull() },
            set: {
                val in
                if !val{
                        linkActive = false;
                        selectedProductId = nil
                }
            }
        )
        return NavigationStack{
            ScrollView{
                LazyVGrid(columns: gridItemLayout, alignment: .leading, spacing: 16){
                    ForEach(productsFeed.products, id: \.self.id){
                        item in
                        ProductItem(productData: item)
                            .onTapGesture {
                                linkActive = true;
                                selectedProductId = item.id;
                                print("linkActive \(linkActive)")
                                print("finish tap")
                        }
                        
                    }
                }.padding(.all, 16)
            }.navigationDestination(isPresented: isNavigationActive){
                if let productId = selectedProductId{
                    ProductScreen(productId: productId)
                }
                else{
                   EmptyView()
                }
            }
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
