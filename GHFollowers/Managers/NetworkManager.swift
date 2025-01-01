//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Peyman on 1/1/25.
//

import Foundation

class NetworkManager {
    static let share = NetworkManager()
    let baseURL = "https://api.github.com/user/"
    private init () {}
    
    
    func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, String?)-> Void){
        
        let endPoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endPoint) else {
            completed(nil, "This username created an invalid request. pelase try again")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(nil, "Unable to complete your request. please chech your internet connection")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil , "Invalid response from the server. please try again")
                return
            }
            
            guard let data = data else {
                completed(nil,"The data received from the server was invalid. please try again")
                return
            }
           
            do{
                let decoder = JSONDecoder()
                let followers = try decoder.decode([Follower].self, from: data)
                completed(followers, nil)
            }catch{
                completed(nil,"The data received from the server was invalid. please try again")
            }
            
        }
        task.resume()
        
        
        
    }
    
  
}

