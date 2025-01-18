//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Peyman on 12/27/24.
//

import UIKit

class FollowerListVC: UIViewController {

    enum Section { case main }
     
    var username: String!
    var followers: [Follower] = []
    
    var collocationView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers()
        configureDataSource()

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
        collocationView = UICollectionView(frame: view.bounds , collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collocationView)
        collocationView.backgroundColor = .systemBackground
        collocationView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
        
    }
    func getFollowers() {
        
           NetworkManager.shared.getFollowers(for: username, page: 1) { [weak self] result in
               guard let self = self else { return }
               switch result {
               case .success(let followers):
                   self.followers = followers
                   self.updateData()
                   
               case .failure(let error):
                   self.presentGFAlertMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "OK")
               }
           }
    }
    

    func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section , Follower>(collectionView: collocationView, cellProvider:
    {(collectionView, IndexPath, follower) ->UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: IndexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        } )
    }
    
    
    func updateData(){
        var snapshot = NSDiffableDataSourceSnapshot<Section , Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
     
    }

}
