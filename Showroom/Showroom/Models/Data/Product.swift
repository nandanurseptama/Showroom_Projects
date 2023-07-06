//
//  Product.swift
//  Showroom
//
//  Created by miracle on 06/07/23.
//

import Foundation
protocol ProductDataProto{
    var id : Int {set get};
    var name : String {set get};
    var price : Int {set get};
    var priceString : String {set get};
    var priceCurrency : String {set get};
    var thumbnail : String {set get};
}
struct ProductData : ProductDataProto, Identifiable, Codable{
    var id: Int
    
    var name: String
    
    var price: Int
    
    var priceString: String
    
    var priceCurrency: String
    
    var thumbnail: String
    
    
}


struct ProductDetailData : ProductDataProto, Identifiable, Codable{
    var id: Int
    
    var name: String
    
    var price: Int
    
    var priceString: String
    
    var priceCurrency: String
    
    var thumbnail: String
    
    var thumbnails : [String]
    
    var description : String
}
