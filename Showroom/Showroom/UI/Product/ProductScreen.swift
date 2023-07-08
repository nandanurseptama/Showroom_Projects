//
//  ProductScreen.swift
//  Showroom
//
//  Created by miracle on 06/07/23.
//

import SwiftUI

struct ProductScreen: View {
    
    @StateObject var productDetail : ProductDetail = ProductDetail();
    @EnvironmentObject var shoppingCart : ShoppingCart;
    @EnvironmentObject var checkout : Checkout;
    @State var isHasFirstAppear = false;
    @State var amountOrder = "1";
    
    @State var shoppingCartError : String? = nil;
    @State var showOrderSheet : Bool = false;
    @State var isCheckoutScreenShown : Bool = false;
    
    var productId : Int;
    
    init(productId : Int) {
        self.productId = productId
    }
    
    var body: some View {
        let isAlertShown : Binding<Bool> = Binding<Bool>(
            get: {
                self.shoppingCartError != nil
            },
            set: {
                val in // update to false
                if !val{
                    self.shoppingCartError = nil;
                }
            }
        );
        
        NavigationStack{
            builder
                .navigationDestination(isPresented : $isCheckoutScreenShown){
                    CheckoutScreen(items: getOrderItem())
                }
        }.task {
            if !isHasFirstAppear{
                productDetail.setProductId(productId: productId);
                productDetail.load()
                isHasFirstAppear = true
            }
        }.alert(isPresented: isAlertShown){
            Alert(title : Text("Message"), message: Text(shoppingCartError!), dismissButton: .default(Text("Ok")))
        }
        .sheet(isPresented: $showOrderSheet, onDismiss: {
            self.showOrderSheet = false;
            self.amountOrder = "1";
        }){
            amountOrderSheet
                .presentationDetents([.fraction(0.4)])
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
            VStack(alignment: .center){
                ScrollView{
                    VStack(alignment: .leading){
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
                           .padding(.horizontal, 18)
                        Spacer(minLength: 8)
                        Text("\(product.priceCurrency). \(product.priceString)")
                            .fontWeight(.bold)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 16)
                        Spacer(minLength: 8)
                        Divider()
                        Text("\(product.description)")
                            .font(.system(size: 14))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .padding(.horizontal, 18)
                        
                    }
                }
                Spacer()
                HStack{
                    buttonCart
                    buttonOrder
                    
                }.padding(.horizontal, 16)
            }
        } else{
            notFoundView
        }
    }
    var buttonCart : some View{
        Button(action : {
            addToCart();
        }, label: {
            Image(systemName: "cart.fill").foregroundColor(.white)
        })
        .frame(maxHeight : 44)
        .frame(maxWidth : 44)
        .background{
            Color(.systemBlue)
        }.cornerRadius(8)
    }
    var buttonOrder : some View{
        Button(
            action : {
                if !self.showOrderSheet{
                    self.showOrderSheet = true;
                } else{
                    // call createOrder
                    createOrder()
                }
            
        }, label:{
            Text("Order")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        })
        .frame(maxHeight: 44)
        .frame(maxWidth: .infinity)
        .background{
            Color(.systemBlue)
        }
        .cornerRadius(8)
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
    var amountOrderSheet : some View{
        VStack(alignment: .leading, spacing: 16){
            Text("Please fill amount")
            TextField(
                "Amount",
                text: $amountOrder
            ).padding(.all, 16)
            .overlay{
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth : 1)
                    .frame(minHeight: 44)
            }
            .keyboardType(.numberPad)
            buttonOrder
        }.frame(alignment: .topLeading)
            .padding(.all, 16)
    }
    
    // taks
    func addToCart(){
        do{
            try shoppingCart.addToCart(product: self.productDetail.productDetailData!, amount: 1);
            self.shoppingCartError = "Success add item to cart";
        } catch ShoppingCartError.ItemFoundInCart{
            self.shoppingCartError = "Item already in cart";
        }
        catch{
            self.shoppingCartError = "Internal Error";
        }
    }
    func createOrder(){
        self.showOrderSheet = false;
        isCheckoutScreenShown = true;
    }
    func getOrderItem() -> [CartItem]{
        if(self.productDetail.productDetailData == nil){
            return [];
        }
        let newOrder = CartItem(product: self.productDetail.productDetailData!, amountItem: Int(self.amountOrder) ?? 1)
        return [newOrder];
    }
    
}

struct ProductScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProductScreen(productId: 1)
    }
}
