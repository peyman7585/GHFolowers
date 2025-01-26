//
//  String+Ext.swift
//  GHFollowers
//
//  Created by Peyman on 1/26/25.
//

import Foundation

extension String {
    
    func convertToDate() -> Date? {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormat.locale = Locale(identifier: "en_US_POSIX")
        dateFormat.timeZone = .current
        
        return dateFormat.date(from: self)
    }
    
    func convertToDisplayFormat() ->String {
        guard let date = self.convertToDate() else { return "N/A" }
        return date.convertToMounthYearFormat()
    }
}
