//
//  FavoritesListVC.swift
//  GHFollowers
//
//  Created by Peyman on 12/25/24.
//

import UIKit

class FavoritesListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        
        PersistenceManager.retrieveFavorites { result in
            switch result {
            case.success(let favorites):
                print(favorites)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    

 

}
