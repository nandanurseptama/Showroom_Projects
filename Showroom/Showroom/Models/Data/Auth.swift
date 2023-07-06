//
//  Auth.swift
//  Showroom
//
//  Created by miracle on 05/07/23.
//

import Foundation

struct AuthData : Identifiable, Codable{
    let id: Int;
    let email : String;
    let password : String;
}
