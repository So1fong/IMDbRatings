//
//  Film.swift
//  IMDbRatings
//
//  Created by Ekaterina Kozlova on 20.03.2019.
//  Copyright © 2019 Ekaterina Kozlova. All rights reserved.
//

import Foundation
import RealmSwift

class Film: Object
{
    @objc dynamic var poster: String = "http://image.tmdb.org/t/p/w200/"
    @objc dynamic var title: String = ""
    @objc dynamic var rate: Double = 0.0
    @objc dynamic var overview: String = ""
    
    func createFilm(poster: String, title: String, rate: Double, overview: String) -> Film
    {
        let newFilm = Film()
        newFilm.poster = poster
        newFilm.overview = overview
        newFilm.rate = rate
        newFilm.title = title
        return newFilm
    }
}

var topRatedFilms: [Film] = []
