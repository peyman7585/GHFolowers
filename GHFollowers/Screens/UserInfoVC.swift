//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Peyman on 1/21/25.
//

import UIKit

class UserInfoVC: UIViewController {

    var username: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(disMissVC))
        navigationItem.rightBarButtonItem = doneButton
        
        NetworkManager.shared.getUserInfo(for: username){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
                
            case .success(let user):
                print(user)
            case .failure(let error):
                self.presentGFAlertMainThread(title: "Error", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    @objc func disMissVC() {
        dismiss(animated: true)
    }

}
