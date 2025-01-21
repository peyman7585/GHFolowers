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
        
        print(username!)
    }
    
    @objc func disMissVC() {
        dismiss(animated: true)
    }

}
