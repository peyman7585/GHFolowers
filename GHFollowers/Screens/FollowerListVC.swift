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
    var filteredFollowers: [Follower] = []
    var isSearching = false
    var page = 1
    var hasMoreFollower = true
    var collocationView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getFollowers(username: username, page: page)
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
        collocationView.delegate = self
        collocationView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
        
    }
    
    func configureSearchController(){
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
    }
    func getFollowers(username : String ,page : Int) {
        showLoadingView()
           NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
               guard let self = self else { return }
               self.dismissLoadingView()
               switch result {
               case .success(let followers):
                   if followers.count > 100 {  self.hasMoreFollower = false }
                   self.followers.append(contentsOf: followers)
                   
                   if self.followers.isEmpty {
                       let message = "This user doesnt have any follower. Go follow them 😁"
                       DispatchQueue.main.sync { self.showEmptyStateView(with: message, in: self.view) }
                       return
                   }
                   self.updateData(on: self.followers)
                   
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
    
    
    func updateData(on followers: [Follower]){
        var snapshot = NSDiffableDataSourceSnapshot<Section , Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
     
    }

}


extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollower else { return }
            
            page += 1
            getFollowers(username: username, page: page)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        
        let destVC = UserInfoVC()
        destVC.username = follower.login
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
    
}

extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: followers)
    }
    
}
