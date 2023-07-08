//
//  OrderItemView.swift
//  Showroom
//
//  Created by miracle on 08/07/23.
//

import SwiftUI

struct OrderItemView: View {
    let orderItem : OrderItem
    
    @State var isExpanded : Bool = false;
    @EnvironmentObject var checkout : Checkout;
    @State var onCancelOrderError : String? = nil;
    init(orderItem: OrderItem) {
        self.orderItem = orderItem
    }
    var body: some View {
        VStack(alignment : .leading){
            HStack(alignment:.center){
                Text("Order Number : \(orderItem.id)")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Spacer()
                Text(" \(Date.init(fromMillisecondsSince1970: orderItem.orderTime).formatToString())")
                    .font(.system(size: 12))
            }.frame(
                maxWidth: .infinity
            ).padding(.bottom, 4)
            HStack{
                Text("Total Items : \(orderItem.items.count) ").fontWeight(.bold).foregroundColor(.gray)
                Spacer()
                Text("Expand")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        self.isExpanded = !self.isExpanded
                    }
            }.frame(
                maxWidth: .infinity
            ).padding(.bottom, 4)
            ItemList
            TotalOrderValueText
            CanCancelItem
            Divider()
        }.frame(
            maxWidth: .infinity,
            alignment : .topLeading
        ).alert(isPresented: Binding<Bool>(get: {
            self.onCancelOrderError != nil
        }, set: {
            val in
            if !val{
                self.onCancelOrderError = nil;
            }
        }), content: {
            Alert(
                title: Text("Cancel Order Error"),
                message: Text("\(self.onCancelOrderError ?? "")"),
                dismissButton: .default(Text("OK"))
            )
        })
    }
    var totalOrderValue : Int{
        self.orderItem.items.reduce(0,{
            $0 + ($1.amountItem * $1.product.price)
        })
    }
    var priceCurrency : String{
        if self.orderItem.items.isEmpty{
            return "";
        } else{
            return self.orderItem.items.first?.product.priceCurrency ?? "";
        }
    }
    
    var TotalOrderValueText : some View{
        Text("Total Order \(priceCurrency). \(totalOrderValue)").fontWeight(.bold).foregroundColor(.gray);
    }
    
    @ViewBuilder var ItemList : some View{
        Group{
            if isExpanded{
                VStack{
                    ForEach(self.orderItem.items, id : \.self.product.id){
                        item in
                        ItemView(item: item)
                    }
                }
            } else{
                EmptyView()
            }
        }.animation(.linear, value: 1)
    }
    
    func ItemView(item : CartItem) -> some View{
        return HStack{
            RemoteImageView(
                url : URL(string:item.product.thumbnail)!,
                placeholder: {
                    EmptyView()
                },
                image: {
                    $0.scaledToFit().aspectRatio(1, contentMode: .fit)
                }
            )
            VStack(alignment : .leading){
                Text(item.product.name)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .font(.system(size: 18))
                Text("\(item.amountItem) X \(item.product.priceCurrency). \(item.product.price)")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
                Text("\(item.product.priceCurrency). \(item.amountItem * item.product.price)")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
            }
        }.frame(
            maxHeight : 70,
            alignment: .leading
        ).padding(.horizontal, 8)
    }
    @ViewBuilder var CanCancelItem : some View{
        if self.checkout.canCancel(orderTime: self.orderItem.orderTime){
            VStack(alignment:.leading){
                Text("You can cancel this order before \(self.checkout.getCancelDateString(orderTime: self.orderItem.orderTime))")
                    .foregroundColor(.gray)
                    .font(.system(size:12))
                    .padding(.bottom, 8)
                Button(
                    action : {
                        cancelOrder()
                    },
                    label: {
                        Text("Cancel Now")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .font(.system(size:12))
                    }
                ).padding(.all, 8)
                .background{
                    Color(.red)
                }.cornerRadius(5)
            }.padding(.vertical, 16)
        } else{
            EmptyView()
        }
    }
    
    func cancelOrder(){
        do{
            try  checkout.cancelOrder(orderId: self.orderItem.id);
            print("cancel order success")
        } catch CheckoutError.CannotCancelOrder{
            self.onCancelOrderError = "Cannot cancel order. Exceed time to checkout";
        } catch CheckoutError.OrderNotFound{
            self.onCancelOrderError = "Order not found";
        }
        catch{
            self.onCancelOrderError = "Internal Error";
        }
        return;
    }
}

struct OrderItemView_Previews: PreviewProvider {
    static var previews: some View {
        OrderItemView(orderItem: Checkout.orderItemExample).environmentObject(Checkout());
    }
}
