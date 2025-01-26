//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Peyman on 1/26/25.
//

import Foundation

extension Date {
    
    func convertToMounthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
