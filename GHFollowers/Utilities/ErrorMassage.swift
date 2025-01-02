//
//  ErrorMassage.swift
//  GHFollowers
//
//  Created by Peyman on 1/2/25.
//

import Foundation

enum ErrorMassage: String{
    
    case invalidUsername = "This username created an invalid request. please try again"
    case unableToComplete = "Unable to complete your request. please chech your internet connection"
    case invalidResponse = "Invalid response from the server. please try again"
    case invalidData = "The data received from the server was invalid. please try again"
}
