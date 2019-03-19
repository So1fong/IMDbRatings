//
//  FilmVC.swift
//  IMDbRatings
//
//  Created by Ekaterina Kozlova on 19.03.2019.
//  Copyright © 2019 Ekaterina Kozlova. All rights reserved.
//

import UIKit

class FilmVC: UIViewController
{

    var removeButton = UIBarButtonItem()
    var addButton = UIBarButtonItem()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        removeButton = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(removeButtonTapped))
        removeButton.tintColor = UIColor.red
        addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonTapped()
    {
        navigationItem.setRightBarButton(nil, animated: false)
        navigationItem.rightBarButtonItem = removeButton
    }
    
    @objc func removeButtonTapped()
    {
        navigationItem.setRightBarButton(nil, animated: false)
        navigationItem.rightBarButtonItem = addButton
    }
}
