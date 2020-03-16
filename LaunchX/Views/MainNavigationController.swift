//
//  MainNavigationController.swift
//  LaunchX
//
//  Created by Christophe Delhaze on 15/3/20.
//  Copyright © 2020 Christophe Delhaze. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    fileprivate func setupNavigationBar() {
        //Add background to the navigation bar
        setBackgroundImage(UIImage(named: "NavBar"))
        
        //Change navigation bar font.ß
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // To display a taller Navigation bar
        navigationBar.frame.size.height = 66
    }
    
}
