//
//  RegisterScreen.swift
//  Showroom
//
//  Created by miracle on 05/07/23.
//

import SwiftUI

struct RegisterScreen: View {
    @State var email : String = "";
    @State var password : String = "";
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .center, spacing:16){
            Spacer()
            Text("Register to Showroom")
                .font(.system(size : 24))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 18)
            TextField("Email", text:$email)
                .padding(8)
            .overlay{
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth : 1)
                    .frame(minHeight: 44)
            }
            .textInputAutocapitalization(.never)
            SecureField("Password", text:$password)
                .padding(8)
            .overlay{
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth : 1)
                    .frame(minHeight: 44)
            }
            .textInputAutocapitalization(.never)
            Button{
                print("Login button pressed")
            } label: {
                Text("Login")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .background{
                Color(.systemBlue)
            }.cornerRadius(8)
            Spacer()
            HStack{
                Text("Already have an account ?")
                Text("Login here")
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                
            }
        }.padding(8)
    }
}

struct RegisterScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegisterScreen()
    }
}
