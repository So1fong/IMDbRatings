//
//  FilmVC.swift
//  IMDbRatings
//
//  Created by Ekaterina Kozlova on 19.03.2019.
//  Copyright © 2019 Ekaterina Kozlova. All rights reserved.
//

import UIKit
import RealmSwift
import RxCocoa
import RxSwift

var tempImage: UIImage?

class FilmVC: UIViewController
{
    @IBOutlet weak var filmTableView: UITableView!
    let realm = try! Realm()

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    var removeButton = UIBarButtonItem()
    var addButton = UIBarButtonItem()
    var filmDescription: Observable<[Film]>!
    let disposeBag = DisposeBag()
    var rowNumbers = 0
    
    func dataBind()
    {
        filmDescription.bind(to: filmTableView.rx.items(cellIdentifier: "filmCell", cellType: FilmTableViewCell.self)) { (_, film: Film, cell: FilmTableViewCell) in
            cell.posterImageView.imageFromServerURL(film.poster, placeHolder: nil)
            tempImage = cell.posterImageView.image
            cell.descriptionLabel.text = film.overview
            cell.titleLabel.text = film.title
            cell.ratingLabel.text = "Рейтинг: " + String(film.rate)
            self.filmTableView.rowHeight = UITableView.automaticDimension
            self.filmTableView.estimatedRowHeight = UITableView.automaticDimension
            
        }.disposed(by: disposeBag)
    }
    
    var tempArray: [Film] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
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
        tempArray.append(topRatedFilms[myIndex])
        filmDescription = Observable.just(tempArray)
        dataBind()
    }
    
    func deleteImage(fileName: String)
    {
        let fileManager = FileManager.default
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let dirPath = paths.first else
        {
            return
        }
        let filePath = "\(dirPath)/\(fileName).jpg"
        do
        {
            try fileManager.removeItem(atPath: filePath)
        }
        catch let error as NSError
        {
            print(error.debugDescription)
        }
    }
    
    @objc func addButtonTapped()
    {
        navigationItem.setRightBarButton(nil, animated: false)
        navigationItem.rightBarButtonItem = removeButton
        var favoriteFilm = Film()
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = String(myIndex) + ".jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let data = tempImage?.jpegData(compressionQuality: 1.0),
            !FileManager.default.fileExists(atPath: fileURL.path)
        {
            do
            {
                try data.write(to: fileURL)
            } catch {
                print("error saving file:", error)
            }
        }
        favoriteFilm = favoriteFilm.createFilm(poster: fileURL.relativeString, title: topRatedFilms[myIndex].title, rate: topRatedFilms[myIndex].rate, overview: topRatedFilms[myIndex].overview)
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
        favoriteFilm = favoriteFilm.createFilm(poster: topRatedFilms[myIndex].poster, title: topRatedFilms[myIndex].title, rate: topRatedFilms[myIndex].rate, overview: topRatedFilms[myIndex].overview)
        try! realm.write
        {
            if let filmToDelete = checkObjectInRealm(title: topRatedFilms[myIndex].title)
            {
                realm.delete(filmToDelete)
                deleteImage(fileName: String(myIndex))
            }
        }
    }
}
