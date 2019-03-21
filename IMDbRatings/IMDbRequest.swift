//
//  IMDbRequests.swift
//  IMDbRatings
//
//  Created by Ekaterina Kozlova on 18.03.2019.
//  Copyright © 2019 Ekaterina Kozlova. All rights reserved.
//

import Foundation

protocol RequestDelegate
{
    func reloadTableView()
}

var contentPage = 1

class IMDbRequest
{
    var requestDelegate: RequestDelegate?
    
    func topRatedRequest()
    {
        let apiKey = "08aab06166b71e9d8236e125b6b285ef"
        let language = "ru-RU"
        let region = "Russia"
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=" + apiKey + "&language=" + language + "&page=" + String(contentPage) + "&region=" + region) else { return }
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
                let page = json
                var resultDictionary: NSDictionary
                let resultsArray = page.value(forKey: "results") as! NSArray
                let currentCount = topRatedFilms.count
                for i in 0..<resultsArray.count
                {
                    topRatedFilms.append(Film())
                    resultDictionary = resultsArray[i] as! NSDictionary
                    topRatedFilms[i + currentCount].poster += resultDictionary.value(forKey: "poster_path") as! String
                    topRatedFilms[i + currentCount].title = resultDictionary.value(forKey: "title") as! String
                    topRatedFilms[i + currentCount].rate = resultDictionary.value(forKey: "vote_average") as! Double
                    topRatedFilms[i + currentCount].overview = resultDictionary.value(forKey: "overview") as! String
                }
                self.requestDelegate?.reloadTableView()
            }
            catch
            {
                print(error)
            }
            }.resume()
    }
}
