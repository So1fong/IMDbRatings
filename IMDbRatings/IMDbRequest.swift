//
//  IMDbRequests.swift
//  IMDbRatings
//
//  Created by Ekaterina Kozlova on 18.03.2019.
//  Copyright © 2019 Ekaterina Kozlova. All rights reserved.
//

import Foundation
import RealmSwift

protocol RequestDelegate
{
    func reloadTableView()
}

struct FilmDescription: RealmCollectionValue
{
    var poster: String = "http://image.tmdb.org/t/p/w200/"
    var title: String = ""
    var rate: Double = 0.0
    var overwiev: String = ""
}

class Film: Object
{
     //@objc dynamic
     @objc dynamic var poster: String = "http://image.tmdb.org/t/p/w200/"
     @objc dynamic var title: String = ""
     @objc dynamic var rate: Double = 0.0
     @objc dynamic var overview: String = ""
     //let films = List<Film>()
    
    func createFilm(poster: String, title: String, rate: Double, overview: String) -> Film
    {
        let newFilm = Film()
        newFilm.poster = poster
        newFilm.overview = overview
        newFilm.rate = rate
        newFilm.title = title
        return newFilm
    }
    
    //@objc dynamic var filmID = UUID().uuidString

    //override static func primaryKey() -> String?
    //{
    //        return "filmID"
    //}
}

var topRatedFilms: [FilmDescription] = [FilmDescription()]

class IMDbRequest
{
    var requestDelegate: RequestDelegate?
    
    func topRatedRequest(page: Int)
    {
        let apiKey = "08aab06166b71e9d8236e125b6b285ef"
        let language = "ru-RU"
        let region = "Russia"
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=" + apiKey + "&language=" + language + "&page=" + String(page) + "&region=" + region) else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        session.dataTask(with: request) { (data, response, error)  in
            if error != nil
            {
                if let error = error as NSError?
                {
                    if error.domain == NSURLErrorDomain || error.code == NSURLErrorCannotConnectToHost
                    {
                        print("error")
                    }
                }
                return
            }
            guard let data = data else { return }
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                //print(json)
                let page = json
                var resultDictionary: NSDictionary
                let resultsArray = page.value(forKey: "results") as! NSArray
                //print("RESULTS ARRAY \(resultsArray) COUNT \(resultsArray.count)")
                for i in 0..<resultsArray.count
                {
                    topRatedFilms.append(FilmDescription())
                    resultDictionary = resultsArray[i] as! NSDictionary
                    topRatedFilms[i].poster += resultDictionary.value(forKey: "poster_path") as! String
                    topRatedFilms[i].title = resultDictionary.value(forKey: "title") as! String
                    
                    topRatedFilms[i].rate = resultDictionary.value(forKey: "vote_average") as! Double
                    topRatedFilms[i].overwiev = resultDictionary.value(forKey: "overview") as! String
                    print(topRatedFilms[i].poster)
                    print(topRatedFilms[i].title)
                    print(topRatedFilms[i].rate)
                    print(topRatedFilms[i].overwiev)
                }
                self.requestDelegate?.reloadTableView()
                //if (result.contains("Bad credentials")) || (result.contains("Requires authentication"))
                //{
                    //self.alertControllerDelegate?.showAuthenticationAlertController()
                //}

            }
            catch
            {
                print(error)
            }
            }.resume()
    }
}
