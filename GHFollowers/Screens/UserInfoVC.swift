//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Peyman on 1/21/25.
//

import UIKit

class UserInfoVC: UIViewController {

    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    var itemViews: [UIView] = []
    
    var username: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        layoutUI()
        getUserInfo()
       
    }
    
    func configureViewController(){
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(disMissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func getUserInfo(){
        NetworkManager.shared.getUserInfo(for: username){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
                
            case .success(let user):
                DispatchQueue.main.async {
                    self.add(childVc: GFUserInfoHeaderVC(user: user), to: self.headerView)
                    self.add(childVc: GFRepoItemVC(user: user), to: self.itemViewOne)
                    self.add(childVc: GFFollowerItemVC(user: user), to: self.itemViewTwo)
                }
               
            case .failure(let error):
                self.presentGFAlertMainThread(title: "Error", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    
    func layoutUI() {
        let padding: CGFloat = 20
        itemViews = [headerView,itemViewOne,itemViewTwo]
        
        for itemview in itemViews {
            view.addSubview(itemview)
            itemview.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            ])
        }
 
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: 140),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: 140),
            
        ])
    }
    
    func add(childVc: UIViewController, to containerView: UIView){
        addChild(childVc)
        containerView.addSubview(childVc.view)
        childVc.view.frame = containerView.bounds
        childVc.didMove(toParent: self)
    }
    
    
    @objc func disMissVC() {
        dismiss(animated: true)
    }
}
