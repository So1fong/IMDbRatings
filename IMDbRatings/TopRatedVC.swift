//
//  TopRatedVC.swift
//  IMDbRatings
//
//  Created by Ekaterina Kozlova on 18.03.2019.
//  Copyright © 2019 Ekaterina Kozlova. All rights reserved.
//

import UIKit
import RxSwift

let request: IMDbRequest = IMDbRequest()
var myIndex = 0

class TopRatedVC: UIViewController, RequestDelegate, UITableViewDelegate, UITableViewDataSource
{
    func loadImage(url: URL)
    {
        var image = UIImage(named: "")
        let data = try? Data(contentsOf: url)
        image = UIImage(data: data!)
        tempImage = image
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return topRatedFilms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topRatedCell", for: indexPath) as! TopRatedTableViewCell
        if topRatedFilms.count != 0
        {
            cell.descriptionLabel.text = topRatedFilms[indexPath.row].overwiev
            if let url = URL(string: topRatedFilms[indexPath.row].poster)
            {
                DispatchQueue.main.async
                {
                    self.loadImage(url: url)
                    cell.posterImageView.image = tempImage
                }
            }
            cell.titleLabel.text = String(indexPath.row+1) + ". " + topRatedFilms[indexPath.row].title
            cell.ratingLabel.text = "Рейтинг: " + String(topRatedFilms[indexPath.row].rate)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        myIndex = indexPath.row
    }
    
    func reloadTableView()
    {
        DispatchQueue.main.async
        {
            self.topRatedTableView.reloadData()
        }
    }
    
    @IBOutlet weak var topRatedTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        request.requestDelegate = self
        topRatedTableView.delegate = self
        topRatedTableView.dataSource = self
        request.topRatedRequest(page: 1)
        topRatedTableView.rowHeight = 300
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorites", style: .plain, target: self, action: #selector(favoritesButtonTapped))
    }
    
    @objc func favoritesButtonTapped()
    {
        performSegue(withIdentifier: "toFavorites", sender: nil)
    }
}
