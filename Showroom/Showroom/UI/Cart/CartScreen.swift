//
//  CartScreen.swift
//  Showroom
//
//  Created by miracle on 07/07/23.
//

import SwiftUI

struct CartScreen: View {
    @EnvironmentObject private var shoppingCart : ShoppingCart;
    
    var gridItem : [GridItem] = [GridItem(.adaptive(minimum:0))];
    
    @State private var isCheckoutScreenPresented = false;
    
    var body: some View {
        NavigationStack{
            builder.task {
                shoppingCart.load();
            }
        }
        
    }
    @ViewBuilder var builder : some View{
        if shoppingCart.items.isEmpty{
            emptyCart
        } else{
                VStack{
                    cartList.task{
                        shoppingCart.load();
                    }
                    checkoutButton
                }.navigationDestination(
                    isPresented: $isCheckoutScreenPresented
                ){
                    CheckoutScreen(items: shoppingCart.items)
                        .onDisappear(perform: {
                            self.isCheckoutScreenPresented = false;
                        })
                }
            
        }
    }
    var checkoutButton : some View{
        HStack{
            Button( action:{
                print("navigate to checkout screen")
                isCheckoutScreenPresented = true;
                print("isCheckoutScreenPresented \(isCheckoutScreenPresented)");
            }, label:{
                Text("Checkout")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
            }).frame(height: 44)
                .frame(maxWidth: .infinity)
                .background{
                    Color(.systemBlue)
                }.cornerRadius(8)
        }.padding(.all,16)
    }
    
    var emptyCart : some View{
        VStack(alignment: .center){
            Text("Your cart is empty")
        }
    }
    
    var cartList : some View{
        ScrollView{
            ForEach(shoppingCart.items, id: \.self.product.id){
                CartItemView(
                    item: $0,
                    actionAddItem: onAddAmount,
                    actionSubstractItem: onSubstractAmount,
                    actionDeleteItem: onDelete
                ).environmentObject(shoppingCart).frame(minHeight:120)
            }
        }
        .padding(.all, 16)
    }
    
    func onDelete(productId : Int){
        shoppingCart.deleteItem(productId: productId);
    }
    func onAddAmount(productId : Int) throws -> Void{
        return try shoppingCart.addAmountToItem(productId: productId);
    }
    func onSubstractAmount(productId : Int) -> Void{
        return shoppingCart.substractAmountToItem(productId: productId);
    }
}

struct CartScreen_Previews: PreviewProvider {
    static var previews: some View {
        CartScreen().environmentObject(ShoppingCart())
    }
}
