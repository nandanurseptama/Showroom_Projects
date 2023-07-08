//
//  OrdersScreen.swift
//  Showroom
//
//  Created by miracle on 08/07/23.
//

import SwiftUI

struct OrdersScreen: View {
    
    @EnvironmentObject var checkout : Checkout;
    
    var body: some View {
        builder.task {
            checkout.load();
        }
    }
    
    @ViewBuilder var builder : some View{
        if checkout.items.isEmpty{
            emptyView
        } else{
            orderList
        }
    }
    
    var emptyView : some View{
        VStack(alignment : .center){
            Text("You do not have any order yet")
        }.frame(alignment : .center)
    }
    var orderList : some View{
        VStack{
            VStack(alignment : .leading){
                Text("Total Orders in Day Chart")
                ChartOrderView()
            }.padding(.all, 16 )
            VStack(alignment : .leading){
                Text("Order Histories")
                ScrollView{
                    VStack{
                        ForEach(checkout.items, id: \.self.id){
                            OrderItemView(orderItem: $0)
                        }
                    }
                }
                .padding(.vertical, 16)
            }.padding(.all, 16)
        }
    }
}

struct OrdersScreen_Previews: PreviewProvider {
    static var previews: some View {
        OrdersScreen().environmentObject(Checkout())
    }
}
