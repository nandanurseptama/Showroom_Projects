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
    
    @EnvironmentObject private var currentAccount : CurrentAccount;
    
    @State private var registerError : String? = nil;

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
            registerErrorView
            Button{
                register();
            } label: {
                Text("Register")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
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
    
    @ViewBuilder var registerErrorView : some View{
        if let registerError = self.registerError{
            HStack{
                Text(registerError)
                    .foregroundColor(.red)
                    .fontWeight(.bold)
            }
        } else{
            EmptyView()
        }
    }
    
    
    // Tasks
    func register(){
        do{
            try currentAccount.register(email: self.email, password: self.password);
        } catch RegisterError.EmailAlreadyUsed{
            self.registerError = "Email already used";
        } catch RegisterError.InvalidEmail{
            self.registerError = "Invalid email";
        } catch{
            self.registerError = nil;
        }
    }
}

struct RegisterScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegisterScreen()
    }
}
