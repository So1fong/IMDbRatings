//
//  FilmVC.swift
//  IMDbRatings
//
//  Created by Ekaterina Kozlova on 19.03.2019.
//  Copyright © 2019 Ekaterina Kozlova. All rights reserved.
//

import UIKit

class FilmVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var filmTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filmCell", for: indexPath) as! FilmTableViewCell
        if let url = URL(string: topRatedFilms[myIndex].poster)
        {
            cell.posterImageView.downloadedFrom(url: url)
        }
        cell.descriptionLabel.text = topRatedFilms[myIndex].overwiev
        cell.titleLabel.text = topRatedFilms[myIndex].title
        cell.ratingLabel.text = "Рейтинг: " + String(topRatedFilms[myIndex].rate)
        filmTableView.rowHeight = cell.descriptionLabel.bounds.height + cell.ratingLabel.bounds.height + cell.titleLabel.bounds.height + 10
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    var removeButton = UIBarButtonItem()
    var addButton = UIBarButtonItem()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        filmTableView.delegate = self
        filmTableView.dataSource = self
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
