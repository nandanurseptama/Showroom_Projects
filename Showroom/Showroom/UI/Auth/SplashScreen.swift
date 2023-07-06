//
//  SplashScreen.swift
//  Showroom
//
//  Created by miracle on 05/07/23.
//

import SwiftUI

struct SplashScreen: View {
    
    var body: some View {
            VStack(alignment: .center, spacing: 16){
                Text("Welcome to Showroom")
                    .fontWeight(.bold)
                    .font(.system(size: 24))
                ProgressView()
            }
        }
    
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
