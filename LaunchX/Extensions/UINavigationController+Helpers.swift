//
//  UINavigationController+Helpers.swift
//  LaunchX
//
//  Created by Christophe Delhaze on 15/3/20.
//  Copyright © 2020 Christophe Delhaze. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    /// Adds an image to the navigation bar background.
    func setBackgroundImage(_ image: UIImage?) {
        guard let image = image else { return }
        
        navigationBar.isTranslucent = true
        navigationBar.barStyle = .black
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        let navigationBarImageView = UIImageView(image: image)
        navigationBarImageView.contentMode = .scaleAspectFill
        navigationBarImageView.clipsToBounds = true
        navigationBarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.insertSubview(navigationBarImageView, belowSubview: navigationBar)
        NSLayoutConstraint.activate([
            navigationBarImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationBarImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationBarImageView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBarImageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor)
        ])
    }
    
}
