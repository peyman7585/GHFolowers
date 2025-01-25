//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Peyman on 1/21/25.
//

import UIKit

class UserInfoVC: UIViewController {

    var headerView = UIView()
    var username: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(disMissVC))
        navigationItem.rightBarButtonItem = doneButton
        layoutUI()
        NetworkManager.shared.getUserInfo(for: username){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
                
            case .success(let user):
                DispatchQueue.main.async {
                    self.add(childVc: GFUserInfoHeaderVC(user: user), to: self.headerView)
                }
               
            case .failure(let error):
                self.presentGFAlertMainThread(title: "Error", message: error.rawValue, buttonTitle: "OK")
            }
        }
       
    }
    
    func layoutUI() {
        
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180)
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
