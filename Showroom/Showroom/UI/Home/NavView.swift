//
//  NavView.swift
//  Showroom
//
//  Created by miracle on 06/07/23.
//

import SwiftUI

class NavigationManager : ObservableObject{
    @Published var activeTabIndex : Int = 0;
}
struct NavView: View {
    @StateObject private var navigationManager : NavigationManager = NavigationManager();
    @StateObject private var shoppingCart : ShoppingCart = ShoppingCart();
    @StateObject private var checkout : Checkout = Checkout();
    @StateObject private var profile :Profile = Profile();
    
    @EnvironmentObject private var currentAccount : CurrentAccount;
    
    var body: some View {
        TabView(selection : $navigationManager.activeTabIndex){
            HomeScreen()
                .tabItem{
                    Label("Home", systemImage: "house.fill")
                }.tag(0)
            CartScreen()
                .tabItem{
                    Label("Cart", systemImage: "cart.fill")
                }.tag(1)
            OrdersScreen().tabItem{
                Label("Orders", systemImage: "square.grid.2x2.fill")
            }.tag(2)
            ProfileScreen()
                .tabItem{
                Label("Profile", systemImage: "person.fill")
            }.tag(3)
        }
        .environmentObject(navigationManager)
        .environmentObject(shoppingCart)
        .environmentObject(checkout)
        .environmentObject(currentAccount)
        .environmentObject(profile);
    }
}
