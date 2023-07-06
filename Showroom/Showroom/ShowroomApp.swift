//
//  ShowroomApp.swift
//  Showroom
//
//  Created by miracle on 05/07/23.
//

import SwiftUI

@main
struct ShowroomApp: App {
    
    @StateObject var currentAccount : CurrentAccount = CurrentAccount()
    
    var body: some Scene {
        WindowGroup{
            NavigationView{
                if let _ = currentAccount.current.auth {
                    NavView()
                } else{
                    LoginScreen().environmentObject(currentAccount)
                }
                
            }.task {
                print("authTask")
                currentAccount.auth()
            }
        }
    }
}
