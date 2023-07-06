//
//  ApiEndpoint.swift
//  Showroom
//
//  Created by miracle on 05/07/23.
//

import Foundation

struct ApiEndpoint{
    
    static var shared : ApiEndpoint = ApiEndpoint();
    
    var baseUrl : String = "https://reqres.in";
    var suffix : String = "/api";
    
    var apiPath : String{
        "\(baseUrl)\(suffix)";
    }
    
    var loginEndpoint: String {
        "\(apiPath)/login";
    }
    
    var registerEndpoint: String {
        "\(apiPath)/login";
    }
    
}
