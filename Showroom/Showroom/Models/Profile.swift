//
//  Profile.swift
//  Showroom
//
//  Created by miracle on 08/07/23.
//

import Foundation

enum ProfileFetchState{
    case Initial;
    case Loading;
    case Error;
    case Loaded;
}

enum ProfileFetchError : Error{
    case NotFound;
    case InternalError;
}
// State Model
class Profile : ObservableObject{
    
    @Published var current : ProfileData? = nil;
    
    @Published var profileFetchState : ProfileFetchState = ProfileFetchState.Initial;
    
    private var localStorage = UserDefaults.standard;
    
    static var emptyProfile = ProfileData(firstName: "", lastName: "", profilePictureData: nil);
    
    
    func load() throws -> Void{
        self.profileFetchState = ProfileFetchState.Loading;
        let profileLocal = localStorage.data(forKey: getProfileDatabaseIndex());
        
        guard let profileLocal = profileLocal else{
            self.current = nil;
            self.profileFetchState = ProfileFetchState.Loaded;
            throw ProfileFetchError.NotFound;
        }
        let jsonDecoder = JSONDecoder()
        do{
            let result = try jsonDecoder.decode(ProfileData.self, from: profileLocal);
            self.current = result;
            self.profileFetchState = ProfileFetchState.Loaded;
            return;
        }catch{
            self.profileFetchState = ProfileFetchState.Loaded;
            throw ProfileFetchError.InternalError;
        }
        
    }
    func updateProfile(
        firstName : String,
        lastName : String
    ) throws -> Void{
        var currentProfile = self.current ?? Profile.emptyProfile;
        
        currentProfile.lastName = lastName;
        currentProfile.firstName = firstName;
        let jsonEncoder = JSONEncoder();
        
        do{
            let result = try jsonEncoder.encode(currentProfile);
            localStorage.set(result, forKey: getProfileDatabaseIndex());
        }catch{
            throw ProfileFetchError.InternalError;
        }
        
        
    }
    func updateProfilePicture(
        profilePictureData : Data
    ) throws -> Void{
        var currentProfile = self.current ?? Profile.emptyProfile;
        
        currentProfile.profilePictureData = profilePictureData;
        let jsonEncoder = JSONEncoder();
        
        do{
            let result = try jsonEncoder.encode(currentProfile);
            localStorage.set(result, forKey: getProfileDatabaseIndex());
            
        }catch{
            throw ProfileFetchError.InternalError;
        }
        
        
    }
    
    func getProfileDatabaseIndex()->String{
        let cred = getCurrentUser();
        guard let cred = cred else{
            return "profile";
        }
        return "\(cred.email)#profile";
    }
    
    
    func getCurrentUser()->Credentials?{
        let local = self.localStorage.data(forKey: "authedUser");
        guard let lc = local else{
            return nil;
        }
        let jsonDecoder = JSONDecoder();
        do{
            let result = try jsonDecoder.decode(Credentials.self, from: lc);
            return result;
        }catch{
            return nil;
        }
        
    }
}
