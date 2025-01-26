//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by Peyman on 1/25/25.
//

import UIKit
class GFFollowerItemVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems(){
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        guard user.followers != 0 else {
            presentGFAlertMainThread(title: "No Followers", message: "This user has no follower, what a shame😑", buttonTitle: "OK")
            return
        }
        delegate.didTapGetFollowers(for: user)
        dismiss(animated: true)
    }
}
