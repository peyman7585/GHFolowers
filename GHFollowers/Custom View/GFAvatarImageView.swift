//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Peyman on 1/13/25.
//

import UIKit

class GFAvatarImageView: UIImageView {

    let placeholderImage = UIImage(named: "avatar-placeholder")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private  func configure() {
            image = placeholderImage
            layer.cornerRadius = 10
            clipsToBounds = true
            translatesAutoresizingMaskIntoConstraints = false
       
        }
}
