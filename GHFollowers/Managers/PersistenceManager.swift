//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by Peyman on 1/26/25.
//

import Foundation

enum PersistenceActionType{
    case add , remove
}

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
        
    }
    
    static func updateWith(favorite: Follower, actionType:PersistenceActionType, completed: @escaping(GFError?) -> Void){
        retrieveFavorites{ result in
            switch result {
            case .success(let favorites):
                var retrivedFavorites = favorites
                switch actionType {
                case .add:
                    guard !retrivedFavorites.contains(favorite) else {
                        completed(.alreadyInFavorites)
                        return
                    }
                    retrivedFavorites.append(favorite)
                case .remove:
                    retrivedFavorites.removeAll{ $0.login == favorite.login}
                }
                
                completed(save(favorites: favorites))
            case.failure(let error):
                completed(error)
            }
        }
    }
    
    static func retrieveFavorites(completed: @escaping(Result<[Follower], GFError>) -> Void){
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else{
            completed(.success([]))
            return
        }
        do{
            let deCoder = JSONDecoder()
            let favorites = try deCoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        }catch{
            completed(.failure(.unableToFavorite))
        }
    }
    
    static func save(favorites: [Follower]) -> GFError? {
        do{
            let encoder = JSONEncoder()
            let encoderFavorites = try encoder.encode(favorites)
            defaults.set(encoderFavorites, forKey: Keys.favorites)
            return nil
        }catch {
            return .unableToFavorite
        }
    }
}
