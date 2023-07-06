//
//  NavView.swift
//  Showroom
//
//  Created by miracle on 06/07/23.
//

import SwiftUI

struct NavView: View {
    var body: some View {
        TabView{
            HomeScreen()
                .tabItem{
                    Label("Home", systemImage: "house.fill")
                }
            Text("Cart").tabItem{
                Label("Cart", systemImage: "cart.fill")
            }
            Text("Order").tabItem{
                Label("Orders", systemImage: "square.grid.2x2.fill")
            }
            Text("Profile").tabItem{
                Label("Profile", systemImage: "person.fill")
            }
        }
    }
}

struct NavView_Previews: PreviewProvider {
    static var previews: some View {
        NavView()
    }
}
