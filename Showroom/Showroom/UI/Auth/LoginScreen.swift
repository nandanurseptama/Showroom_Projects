//
//  LoginScreen.swift
//  Showroom
//
//  Created by miracle on 05/07/23.
//

import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject private var currentAccount : CurrentAccount;
    
    @State var email : String = "";
    @State var password : String = "";
    
    @State private var showAlertError : Bool = false;
    
    var body: some View {
            VStack(alignment: .center, spacing: 16){
                Spacer()
                Text("Login to Showroom")
                    .font(.system(size : 24))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 18)
                TextField("Email", text: $email)
                    .padding(8)
                    .overlay{
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth : 1)
                            .frame(minHeight: 44)
                    }
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $password)
                    .padding(8)
                    .overlay{
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth : 1)
                            .frame(minHeight: 44)
                    }
                    .textInputAutocapitalization(.never)
                Button(
                    action: onLogin
                ){
                    Text("Login")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background{
                    Color(.systemBlue)
                }.cornerRadius(8)
                Spacer()
                HStack{
                    Text("Do not have an account ?")
                    NavigationLink(destination: RegisterScreen()){
                        Text("Register here")
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                    }
                }
            }.padding(8)
            .onChange(of: currentAccount.loginError){ value in
                print("loginError ? \(String(describing: value))")
                if let _ = value{
                    self.showAlertError = true
                } else{
                    self.showAlertError = false
                }
            }.alert(isPresented: $showAlertError){
                Alert(title: Text("Login Error"), message: Text(currentAccount.loginError!.message), dismissButton: .default(Text("Ok")))
            }
    }
    func onLogin(){
        currentAccount.login(email: email, password: password);
        return
    }
}

//struct LoginScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginScreen()
//    }
//}
