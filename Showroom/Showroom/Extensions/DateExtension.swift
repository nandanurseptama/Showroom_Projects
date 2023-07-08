//
//  DateExtension.swift
//  Showroom
//
//  Created by miracle on 08/07/23.
//

import Foundation
extension Date{
    
    var millisecondsSince1970 : Int64{
        Int64((self.timeIntervalSince1970 * 1000.0).rounded());
    }
    
    init(fromMillisecondsSince1970: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(fromMillisecondsSince1970) / 1000)
    }
    
    func formatToString(withFormat : String = "yyyy-MM-dd HH:mm")->String{
        
        let dateFormatter = DateFormatter();
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Jakarta")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = withFormat;
        
        let str = dateFormatter.string(from: self);
        return str;
    }
}
