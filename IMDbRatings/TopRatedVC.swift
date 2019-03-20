//
//  TopRatedVC.swift
//  IMDbRatings
//
//  Created by Ekaterina Kozlova on 18.03.2019.
//  Copyright © 2019 Ekaterina Kozlova. All rights reserved.
//

import UIKit
import RxSwift

extension UIImageView
{
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) -> UIImage
    {
        contentMode = mode
        var resultImage = UIImage()
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async()
                {
                    self.image = image
                    resultImage = self.image!
                }
            }.resume()
        return resultImage
    }
    
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) -> UIImage?
    {
        if let url = URL(string: link)
        {
            let image = downloadedFrom(url: url, contentMode: mode)
            return image
        }
        return nil
    }
}

let request: IMDbRequest = IMDbRequest()
var myIndex = 0

class TopRatedVC: UIViewController, RequestDelegate, UITableViewDelegate, UITableViewDataSource
{
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
                cell.posterImageView.image = cell.posterImageView.downloadedFrom(url: url)
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
