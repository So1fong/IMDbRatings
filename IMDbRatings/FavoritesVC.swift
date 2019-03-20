//
//  FavoritesVC.swift
//  IMDbRatings
//
//  Created by Ekaterina Kozlova on 19.03.2019.
//  Copyright © 2019 Ekaterina Kozlova. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class FavoritesVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var favorites: [Film] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoritesTableViewCell
        if favorites.count != 0
        {
            cell.descriptionLabel.text = favorites[indexPath.row].overview
            if let url = URL(string: favorites[indexPath.row].poster)
            {
                cell.posterImageView.downloadedFrom(url: url)
            }
            cell.titleLabel.text = favorites[indexPath.row].title
            cell.ratingLabel.text = "Рейтинг: " + String(favorites[indexPath.row].rate)
        }
        return cell
    }
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool)
    {
        let realm = try! Realm()
        favorites = Array(realm.objects(Film.self))
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
    }
}
