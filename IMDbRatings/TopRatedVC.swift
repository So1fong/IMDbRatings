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
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit)
    {
        contentMode = mode
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
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit)
    {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
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
            //cell.descriptionLabel.num
            //cell.descriptionLabel.sizeToFit()
            //cell.descriptionLabel.bounds.size.height = setLabelHeight(label: cell.descriptionLabel, text: topRatedFilms[indexPath.row].overwiev)
            if let url = URL(string: topRatedFilms[indexPath.row].poster)
            {
                cell.posterImageView.downloadedFrom(url: url)
            }
            cell.titleLabel.text = String(indexPath.row+1) + ". " + topRatedFilms[indexPath.row].title
            //cell.titleLabel.sizeToFit()
            cell.ratingLabel.text = "Рейтинг: " + String(topRatedFilms[indexPath.row].rate)
        }
        //topRatedTableView.rowHeight = UITableView.automaticDimension
        //topRatedTableView.estimatedRowHeight = 44.0
        
        //var topRatedTableViewHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()
        //topRatedTableViewHeightConstraint.constant = topRatedTableView.contentSize.height
        
        //topRatedTableView.rowHeight = topRatedTableView.contentSize.height
        //topRatedTableView.rowHeight = cell.descriptionLabel.bounds.height + cell.ratingLabel.bounds.height + cell.titleLabel.bounds.height + 10
        return cell
    }
    
    //func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    //{
    //    return UITableView.automaticDimension
    //}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        myIndex = indexPath.row
    }
    
    func setLabelHeight(label: UILabel, text: String) -> CGFloat
    {
        //let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        //label.font = font
        label.text = text
        label.sizeToFit()
        //CGRect newFrame = label.frame
        //newFrame.size.height = expectedLabelSize.height
        //label.frame = newFrame;
        
        return label.frame.height
    }
    
    //let font = UIFont(name: "Helvetica", size: 20.0)
    
    //var height = heightForView("This is just a load of text", font: font, width: 100.0)
    
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
