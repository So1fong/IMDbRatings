//
//  FilmVC.swift
//  IMDbRatings
//
//  Created by Ekaterina Kozlova on 19.03.2019.
//  Copyright © 2019 Ekaterina Kozlova. All rights reserved.
//

import UIKit
import RealmSwift

var savedFilms: [Film] = []

class FilmVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var filmTableView: UITableView!
    let realm = try! Realm()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filmCell", for: indexPath) as! FilmTableViewCell
        if let url = URL(string: topRatedFilms[myIndex].poster)
        {
            cell.posterImageView.image = cell.posterImageView.downloadedFrom(url: url)
        }
        cell.descriptionLabel.text = topRatedFilms[myIndex].overwiev
        cell.titleLabel.text = topRatedFilms[myIndex].title
        cell.ratingLabel.text = "Рейтинг: " + String(topRatedFilms[myIndex].rate)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
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
        if let _ = checkObjectInRealm(title: topRatedFilms[myIndex].title)
        {
            navigationItem.rightBarButtonItem = removeButton
        }
        else
        {
            navigationItem.rightBarButtonItem = addButton
        }
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    @objc func addButtonTapped()
    {
        navigationItem.setRightBarButton(nil, animated: false)
        navigationItem.rightBarButtonItem = removeButton
        var favoriteFilm = Film()
        favoriteFilm = favoriteFilm.createFilm(poster: topRatedFilms[myIndex].poster, title: topRatedFilms[myIndex].title, rate: topRatedFilms[myIndex].rate, overview: topRatedFilms[myIndex].overwiev)
        if let _ = checkObjectInRealm(title: favoriteFilm.title) { }
        else
        {
            try! realm.write
            {
                realm.add(favoriteFilm)
            }
        }
    }
    
    func checkObjectInRealm(title: String) -> Film?
    {
        let condition = NSPredicate(format: "title=%@", title)
        let neededFilm = realm.objects(Film.self).filter(condition).first
        
        if neededFilm?.title == title
        {
            return neededFilm
        }
        return nil
    }
    
    @objc func removeButtonTapped()
    {
        navigationItem.setRightBarButton(nil, animated: false)
        navigationItem.rightBarButtonItem = addButton
        var favoriteFilm = Film()
        favoriteFilm = favoriteFilm.createFilm(poster: topRatedFilms[myIndex].poster, title: topRatedFilms[myIndex].title, rate: topRatedFilms[myIndex].rate, overview: topRatedFilms[myIndex].overwiev)
        try! realm.write
        {
            if let filmToDelete = checkObjectInRealm(title: topRatedFilms[myIndex].title)
            {
                realm.delete(filmToDelete)
            }
        }
    }
}
