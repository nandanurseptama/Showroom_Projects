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
    
    @State private var loginError : String? = nil;
    
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
                    action : onLogin
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
                    NavigationLink(destination: RegisterScreen().environmentObject(currentAccount)){
                        Text("Register here")
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                    }
                }
            }.padding(8)
                .alert(isPresented: isAlertShown()){
                Alert(title: Text("Login Error"), message: Text(currentAccount.loginError!.message), dismissButton: .default(Text("Ok")))
            }
    }
    
    func isAlertShown()->Binding<Bool>{
        return Binding<Bool>(get: {
            self.loginError != nil
        }, set: {
            val in
            if !val{
                self.loginError = nil;
            }
        });
    }
    func onLogin(){
        do{
            try currentAccount.login(email: email, password: password);
        } catch LoginError.invalidEmail{
            self.loginError = LoginError.invalidEmail.message;
        } catch LoginError.emailOrPasswordWrong{
            self.loginError = LoginError.emailOrPasswordWrong.message;
        } catch LoginError.emailRequired{
            self.loginError = LoginError.emailRequired.message;
        } catch LoginError.passwordRequired{
            self.loginError = LoginError.passwordRequired.message;
        } catch LoginError.notfound{
            self.loginError = LoginError.notfound.message;
        }
        catch{
            self.loginError = "Internal Error";
        }
        return;
    }
}

//struct LoginScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginScreen()
//    }
//}
