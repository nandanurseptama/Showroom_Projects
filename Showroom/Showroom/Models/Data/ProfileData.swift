//
//  Profile.swift
//  Showroom
//
//  Created by miracle on 05/07/23.
//

import Foundation
struct ProfileData : Codable, Equatable{
    
    var firstName : String;
    var lastName : String;
    
    var profilePictureData : Data?;
}
