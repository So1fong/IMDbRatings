//
//  IMDbRequests.swift
//  IMDbRatings
//
//  Created by Ekaterina Kozlova on 18.03.2019.
//  Copyright © 2019 Ekaterina Kozlova. All rights reserved.
//

import Foundation

struct filmDescription
{
    var poster: String = ""
    var title: String = ""
    var rate: String = ""
    var overwiev: String = ""
}

var topRatedFilms: [filmDescription] = [filmDescription()]

class IMDbRequest
{
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
                print(json)
                let page = json
                let resultsArray = page.value(forKey: "results") as! NSArray
                for 
                let resultDictionary = results[i] as! NSDictionary
                topRatedFilms[0].title = result.value(forKey: "title") as! String
                print(topRatedFilms[0].title)
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
