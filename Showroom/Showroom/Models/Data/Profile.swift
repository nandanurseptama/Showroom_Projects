//
//  Profile.swift
//  Showroom
//
//  Created by miracle on 05/07/23.
//

import Foundation
struct ProfileData : Identifiable, Codable{
    
    let id : Int;
    
    let firstName : String;
    let lastName : String;
    
    let profilePicturePath : String;
}
