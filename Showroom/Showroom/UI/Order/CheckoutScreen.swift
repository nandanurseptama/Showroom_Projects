//
//  CheckoutScreen.swift
//  Showroom
//
//  Created by miracle on 07/07/23.
//

import SwiftUI

struct CheckoutScreen: View {
    
    @State private var address : String = "";
    
    @EnvironmentObject private var checkout : Checkout;
    @EnvironmentObject private var shoppingCart : ShoppingCart;
    
    @State private var addressFieldError : String? = nil;
    
    @Environment(\.dismiss) var dismiss;
    
    @State private var isOrderSuccess : Bool = false;
    
    var items : [CartItem];
    
    init(items: [CartItem]) {
        self.items = items
    }
    var grandTotalValue : Int{
        return items.reduce(0, {
            r, item in
            r + (item.product.price * item.amountItem)
        });
    }
    var priceCurrency : String{
        if(items.isEmpty){
            return ""
        }
        return items.first?.product.priceCurrency ?? "";
    }
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                ScrollView{
                    ForEach(items, id: \.self.product.id) { item in
                        CartItemView(item: item)
                    }
                }.padding(.all, 16)
                addressField
                grandTotalText
                buttonProceed
            }.frame(alignment : .topLeading)
        }
        .alert(isPresented: $isOrderSuccess){
            Alert(
                title: Text("Message"),
                message: Text("Order success"),
                dismissButton: .default(Text("OK"), action: {
                    self.isOrderSuccess = false;
                    dismiss();
                })
            )
        }
    }
    @ViewBuilder var addressField : some View{
        VStack(alignment : .leading){
            Text("Your Address")
            TextField("Please fill valid address", text: $address)
                .lineLimit(5)
                .padding(.all, 16)
                .overlay{
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth : 1)
                        .frame(minHeight: 44)
                        .foregroundColor(.gray)
                }.frame(maxWidth: .infinity)
            if let err = self.addressFieldError{
                Text(err).foregroundColor(.red)
                    .fontWeight(.bold)
                    .font(.system(size: 12))
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding(.all, 16)
    }
    
    var grandTotalText : some View{
        Text("Grand total \(priceCurrency). \(grandTotalValue)")
            .fontWeight(.bold)
            .font(.system(size:18)).padding(.horizontal, 18);
    }
    
    
    
    @ViewBuilder var buttonProceed : some View{
        HStack{
            Button(
                action : {
                    createOrder();
                }
            ){
                Text("Proceed")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
            }
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .background{
                Color(.systemBlue)
            }.cornerRadius(8)
        }.padding(.horizontal, 16).padding(.bottom, 16)
    }
    
    func createOrder()->Void{
        self.addressFieldError = nil;
        if(self.address.isEmpty){
            self.addressFieldError = "Address required";
        }
        checkout.createOrder(cartItems: self.items, address: self.address);
        self.isOrderSuccess = true;
        shoppingCart.clearCart();
        return;
        
    }
}

struct CheckoutScreen_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutScreen(items: [ShoppingCart.example]).environmentObject(Checkout());
    }
}
