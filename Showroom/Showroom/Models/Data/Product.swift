//
//  Product.swift
//  Showroom
//
//  Created by miracle on 06/07/23.
//

import Foundation
struct ProductData : Identifiable, Codable{
    var id : Int;
    var name : String;
    var price : Int;
    var priceString : String;
    var priceCurrency : String;
    var thumbnail : String;
}
