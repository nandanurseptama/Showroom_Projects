//
//  CurrentAccount.swift
//  Showroom
//
//  Created by miracle on 05/07/23.
//

import Foundation


enum LoginError : Error{
    case emailRequired
    case invalidEmail
    case passwordRequired
    case emailOrPasswordWrong
}
extension LoginError{
    var message : String{
        switch(self){
        case .emailRequired:
            return "Email required"
        case .invalidEmail:
            return "Invalid email"
        case .passwordRequired:
            return "Password required"
        case .emailOrPasswordWrong:
            return "Email or password wrong"
        }
    }
}

class CurrentAccount : ObservableObject{
    
    init() {
        self.current = Account()
    }
    
    struct Account{
        var auth : AuthData?;
        var profile : ProfileData?;
    }
    
    
    private var localStorage  = UserDefaults.standard
    
    // dependency
    @Published var current : Account;
    @Published var loginError : LoginError? = nil;
    // Tasks
    var isUnauthed : Bool{
        current.auth == nil
    }
    
    func login(email : String, password : String){
        var err = validateEmail(email: email);
        if let e = err{
            self.loginError = e;
            return
        }
        
        err = validatePassword(password: password)
        if let e = err {
            self.loginError = e;
            return;
        }
        

        self.current.auth = AuthData(id: 1, email: email, password: password);
        localStorage.set(email, forKey: "email")
        localStorage.set(password, forKey: "password")
        
        
        return
    }
    func validateEmail(email : String)-> LoginError?{
        if email.isEmpty{
            return LoginError.emailRequired;
        }
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        let isValidEmail = regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) != nil
        if !isValidEmail{
            return LoginError.invalidEmail;
        }
        return nil;
    }
    func validatePassword(password : String) -> LoginError?{
        if password.isEmpty{
            return LoginError.passwordRequired;
        }
        return nil;
    }
    
    
    // authenticating user
    func auth(){
        print("authenting")
        let email : String? = localStorage.string(forKey: "email")
        let password : String? = localStorage.string(forKey: "password")
        
        // check if email or password was nil
        if let e = email, let p = password{
            self.current.auth = AuthData(id: 1, email: e, password: p)
        } else{
            return;
        }
        return;
    }
}
