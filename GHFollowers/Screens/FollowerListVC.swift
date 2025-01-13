//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Peyman on 12/27/24.
//

import UIKit

class FollowerListVC: UIViewController {

    var username: String!
    var collocationView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    func configureCollectionView() {
        collocationView = UICollectionView(frame: view.bounds , collectionViewLayout: createThreeColumnFlowLayout())
        view.addSubview(collocationView)
        collocationView.backgroundColor = .systemPink
        collocationView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
        
    }
    
    func createThreeColumnFlowLayout() -> UICollectionViewFlowLayout {
        
        let width                       = view.bounds.width
        let padding: CGFloat            = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth              = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth                   = availableWidth / 3
        
        let flowLayout                  = UICollectionViewFlowLayout()
        flowLayout.sectionInset         = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize             = CGSize(width: itemWidth, height: itemWidth + 40)
        
        
        
        return flowLayout
    }
    func getFollowers() {
        
           NetworkManager.shared.getFollowers(for: username, page: 1) { result in
              
               switch result {
               case .success(let followers):
                   print(followers)
                   
               case .failure(let error):
                   self.presentGFAlertMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "OK")
               }

           }
    }

}
