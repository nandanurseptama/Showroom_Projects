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
    case notfound;
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
        case .notfound:
            return "User not found"
        }
    }
}
struct Credentials : Codable{
    var email : String;
    var password : String;
}

enum RegisterError : Error{
    case InvalidEmail;
    case EmailAlreadyUsed;
}

struct Account{
    var auth : Credentials?;
}

class CurrentAccount : ObservableObject{
    
    init() {
        self.current = Account()
    }
    
    private var localStorage  = UserDefaults.standard
    
    // dependency
    @Published var current : Account;
    @Published var loginError : LoginError? = nil;
    
    // Tasks
    var isUnauthed : Bool{
        current.auth == nil
    }
    
    func login(email : String, password : String)throws -> Void{
        var err = validateEmail(email: email);
        if let e = err{
            throw e;
        }
        
        err = validatePassword(password: password)
        if let e = err {
            throw e;
        }
        
        let credFromLocal = getCredential(email: email.lowercased());
        guard let c = credFromLocal else{
            throw LoginError.notfound;
        }
        
        if c.email.lowercased() != email.lowercased() || password != c.password{
            throw LoginError.emailOrPasswordWrong;
        }
        let jsonEncoder = JSONEncoder()
        do{
            let result = try jsonEncoder.encode(c);
            localStorage.set(result, forKey: "authedUser");
            self.current.auth = c;
        }catch{
            return;
        }
        
        
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
        let authedUser = self.localStorage.data(forKey: "authedUser");
        
        guard let authedUser = authedUser else{
            return;
        }
        let jsonDecoder = JSONDecoder()
        do{
            let r = try jsonDecoder.decode(Credentials.self, from: authedUser)
            self.current.auth = r;
        }catch{
            return;
        }
        
        return;
    }
    
    func register(email : String, password : String)throws -> Void{
        let credential = getCredential(email: email);
        
        // case email not exists in DB
        guard let _ = credential else{
            createCredential(email: email, password: password);
            return;
        }
        
        throw RegisterError.EmailAlreadyUsed;
    }
    
    func createCredential(email : String , password : String)->Void{
        var credentials = credentialDatabase();
        credentials.append(Credentials(email: email.lowercased(), password: password));
        
        let jsonEncoder = JSONEncoder();
        
        do{
            let result = try jsonEncoder.encode(credentials);
            self.localStorage.set(result, forKey: "credentials");
        }catch{
            return;
        }
    }
    func getCredential(email : String)-> Credentials?{
        let credentials = credentialDatabase();
        
        if credentials.isEmpty{
            return nil;
        }
        
        return credentials.first(where: {
            $0.email.lowercased() == email.lowercased();
        })
    }
    
    func credentialDatabase() -> [Credentials]{
        let localCredentials = self.localStorage.data(forKey: "credentials");
        
        guard let lc = localCredentials else{
            return [];
        }
        
        let jsonDecoder = JSONDecoder();
        
        do{
            let result = try jsonDecoder.decode([Credentials].self, from: lc)
            return result;
        }catch{
            return [];
        }
    }
    func logout(){
        localStorage.set(nil, forKey: "authedUser");
        self.current.auth = nil;
        return;
    }
}
