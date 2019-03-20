//
//  RealmManager.swift
//  IMDbRatings
//
//  Created by Ekaterina Kozlova on 20.03.2019.
//  Copyright © 2019 Ekaterina Kozlova. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager
{
    var database : Realm
    //let sharedInstance = RealmManager()
    
    init()
    {
        database = try! Realm()
    }
    
    func save(film: Film)
    {
        try! database.write
        {
            database.add(film)
        }
    }
   /*
    func fetch()
    {
        DispatchQueue.main.async
            {
            do
            {
                //Do your realm stuff in this queue.
                let realm = try Realm()
                let film = try realm.objects(Film.self)
                if film != nil{
                    let numberOfFilms = film.count
                    //return to main queue to update UI
                    DispatchQueue.main.async{
                        print(numberOfFilms)
                    }
                }
            }catch{
                print(error)
            }
        }
        //var films = database.objects(Film.self)
    }
    */
}
