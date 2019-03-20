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
    //var realm : Realm!
    //var filmsList: Results<Film>
    //{
        //get
        //{
            //return realm.objects(Film.self)
        //}
    //}
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
            cell.posterImageView.downloadedFrom(url: url)
        }
        cell.descriptionLabel.text = topRatedFilms[myIndex].overwiev
        cell.titleLabel.text = topRatedFilms[myIndex].title
        cell.ratingLabel.text = "Рейтинг: " + String(topRatedFilms[myIndex].rate)
        //filmTableView.rowHeight = cell.descriptionLabel.bounds.height + cell.ratingLabel.bounds.height + cell.titleLabel.bounds.height + 10
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
        try! realm.write
        {
            if let _ = checkObjectInRealm(title: topRatedFilms[myIndex].title)
            {
                navigationItem.rightBarButtonItem = removeButton
            }
            else
            {
                navigationItem.rightBarButtonItem = addButton
            }
        }
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    @objc func addButtonTapped()
    {
        navigationItem.setRightBarButton(nil, animated: false)
        navigationItem.rightBarButtonItem = removeButton
        //let film = filmsList[]
        //let db = RealmManager()
        //let favoriteFilm = Film()
        //db.save(film: favoriteFilm.createFilm(poster: "1", title: "2", rate: 3, overview: "4"))
        //db.fetch()
        var favoriteFilm = Film()
        //favoriteFilm.overview = topRatedFilms[myIndex].overwiev
        //favoriteFilm.poster = topRatedFilms[myIndex].poster
        //favoriteFilm.rate = topRatedFilms[myIndex].rate
        //favoriteFilm.title = topRatedFilms[myIndex].title
        favoriteFilm = favoriteFilm.createFilm(poster: topRatedFilms[myIndex].poster, title: topRatedFilms[myIndex].title, rate: topRatedFilms[myIndex].rate, overview: topRatedFilms[myIndex].overwiev)
        //let realm =  try! Realm()
        if let _ = checkObjectInRealm(title: favoriteFilm.title) { }
        else
        {
            try! realm.write
            {
                realm.add(favoriteFilm)
            }
        }
        /*
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let realm = try! Realm()
                let theFilm = realm.objects(Film.self).filter("age == 1").first
                try! realm.write {
                    favoriteFilm.createFilm(poster: "1", title: "2", rate: 3, overview: "4")
                }
            }
        }
         */
        //favoriteFilm.filmID = "id"
        //let key = "id"
        //try? self.realm.write
        //{
            //self.realm.add(favoriteFilm)
        //    self.realm.object(ofType: Film.self, forPrimaryKey: key)
            
        //}
        
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
            if let productToDelete = checkObjectInRealm(title: topRatedFilms[myIndex].title)
            {
                realm.delete(productToDelete)
            }
        }

    }
}
