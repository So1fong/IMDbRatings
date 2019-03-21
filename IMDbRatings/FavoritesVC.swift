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
import RxCocoa
import RxSwift

class FavoritesVC: UIViewController
{
    var favorites: [Film] = []

    func loadImageFromPath(_ name: String) -> UIImage?
    {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = URL(fileURLWithPath: path).appendingPathComponent(name)
        do
        {
            let imageData = try Data(contentsOf: url)
            return UIImage(data: imageData)
        } catch
        {
            print("Error loading image : \(error)")
        }
        return nil
    }

    @IBOutlet weak var favoritesTableView: UITableView!
    
    var favoriteFilms: Observable<[Film]>!
    let disposeBag = DisposeBag()
    
    func dataBind()
    {
        favoritesTableView.dataSource = nil
        favoriteFilms.bind(to: favoritesTableView.rx.items(cellIdentifier: "favoriteCell")) { (row, film, cell) in
            if let favoriteCell = cell as? FavoritesTableViewCell
            {
                if self.favorites.count != 0
                {
                    favoriteCell.descriptionLabel.text = film.overview
                    let posterString = film.poster
                    var distance = 0
                    if let index = posterString.lastIndex(of: "/")
                    {
                        distance = posterString.distance(from: index, to: posterString.endIndex) - 1
                    }
                    let imageName = posterString.suffix(distance)
                    favoriteCell.posterImageView.image = self.loadImageFromPath(String(imageName))
                    favoriteCell.titleLabel.text = film.title
                    favoriteCell.ratingLabel.text = "Рейтинг: " + String(film.rate)
                }
            }
            }.disposed(by: disposeBag)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let realm = try! Realm()
        favorites = Array(realm.objects(Film.self))
        favoriteFilms = Observable.just(self.favorites)
        dataBind()
    }
}
