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
    @StateObject var navigationManager : NavigationManager = NavigationManager();
    
    var body: some View {
        TabView(selection : $navigationManager.activeTabIndex){
            HomeScreen()
                .tabItem{
                    Label("Home", systemImage: "house.fill")
                }.tag(0)
            Text("Cart").tabItem{
                Label("Cart", systemImage: "cart.fill")
            }.tag(1)
            Text("Order").tabItem{
                Label("Orders", systemImage: "square.grid.2x2.fill")
            }.tag(2)
            Text("Profile").tabItem{
                Label("Profile", systemImage: "person.fill")
            }.tag(3)
        }.environmentObject(navigationManager)
    }
}

struct NavView_Previews: PreviewProvider {
    static var previews: some View {
        NavView()
    }
}
