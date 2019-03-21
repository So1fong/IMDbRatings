//
//  TopRatedVC.swift
//  IMDbRatings
//
//  Created by Ekaterina Kozlova on 18.03.2019.
//  Copyright © 2019 Ekaterina Kozlova. All rights reserved.
//

import UIKit

let request: IMDbRequest = IMDbRequest()
var myIndex = 0
var loadMoreFilms = false
let cache = NSCache<NSString, UIImage>()

extension UIImageView
{
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?)
    {
        self.image = nil
        if let cachedImage = cache.object(forKey: NSString(string: URLString))
        {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: URLString)
        {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil
                {
                    print("error")
                    DispatchQueue.main.async
                    {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async
                {
                    if let data = data
                    {
                        if let resultImage = UIImage(data: data)
                        {
                            cache.setObject(resultImage, forKey: NSString(string: URLString))
                            self.image = resultImage
                        }
                    }
                }
            }).resume()
        }
    }
}

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
            cell.descriptionLabel.text = topRatedFilms[indexPath.row].overview
            cell.posterImageView.imageFromServerURL(topRatedFilms[indexPath.row].poster, placeHolder: nil)
            tempImage = cell.posterImageView.image
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let offsetY = scrollView.contentOffset.y
        let height = scrollView.contentSize.height
        if offsetY > height - scrollView.frame.height
        {
            if !loadMoreFilms
            {
                beginLoadMore()
            }
        }
    }
    
    func beginLoadMore()
    {
        loadMoreFilms = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute:
        {
            contentPage += 1
            var newFilms: [Film] = []
            newFilms = topRatedFilms
            topRatedFilms = []
            request.topRatedRequest()
            newFilms.append(contentsOf: topRatedFilms)
            let tempArray = newFilms
            topRatedFilms = newFilms
            newFilms = tempArray
            loadMoreFilms = false
            self.topRatedTableView.reloadData()
        })
    }
    
    @IBOutlet weak var topRatedTableView: UITableView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        request.requestDelegate = self
        topRatedTableView.delegate = self
        topRatedTableView.dataSource = self
        request.topRatedRequest()
        topRatedTableView.rowHeight = 300
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorites", style: .plain, target: self, action: #selector(favoritesButtonTapped))
    }
    
    @objc func favoritesButtonTapped()
    {
        performSegue(withIdentifier: "toFavorites", sender: nil)
    }
}
