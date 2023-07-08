//
//  ProfileFormview.swift
//  Showroom
//
//  Created by miracle on 08/07/23.
//

import SwiftUI

struct ProfileFormview: View {
    
    var firstNameFieldController : Binding<String>;
    var lastNameFieldController : Binding<String>;
    
    init(firstNameFieldController : Binding<String>,  lastNameFieldController : Binding<String>) {
        self.firstNameFieldController = firstNameFieldController;
        self.lastNameFieldController = lastNameFieldController;
    }
    var body: some View {
        VStack(alignment : .leading, spacing: 32){
            TextField("First Name", text: firstNameFieldController)
                .padding(8)
                .overlay{
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth : 1)
                        .frame(minHeight: 44)
                }
            TextField("Last Name", text: lastNameFieldController)
                .padding(8)
                .overlay{
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth : 1)
                        .frame(minHeight: 44)
                }
        }.frame(maxWidth:.infinity, alignment: .topLeading)
    }
}

struct ProfileFormview_Previews: PreviewProvider {
    
    static var firstNameController : Binding<String>{
        Binding<String>(get: {
            ""
        }, set: {
            val in
        })
    }
    static var lastNameController : Binding<String>{
        Binding<String>(get: {
            ""
        }, set: {
            val in
        })
    }
    static var previews: some View {
        ProfileFormview(
            firstNameFieldController: ProfileFormview_Previews.firstNameController,
            lastNameFieldController: ProfileFormview_Previews.lastNameController
        )
    }
}
