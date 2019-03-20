//
//  FilmVC.swift
//  IMDbRatings
//
//  Created by Ekaterina Kozlova on 19.03.2019.
//  Copyright © 2019 Ekaterina Kozlova. All rights reserved.
//

import UIKit
import RealmSwift

var tempImage: UIImage?

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
            
            DispatchQueue.main.async {
                self.loadImage(url: url)
                cell.posterImageView.image = tempImage
            }
            
            //cell.posterImageView.image = cell.posterImageView.downloadedFrom(url: url)
            //if let image = cell.posterImageView.image
            //{
                //tempImage = cell.posterImageView.image
            //}
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
  /*
    public static func fileURLInDocumentDirectory(_ fileName: String) -> URL {
        
        return self.documentsDirectoryURL.appendingPathComponent(fileName)
    }
    
    public static func storeImageToDocumentDirectory(image: UIImage, fileName: String) -> URL? {
        guard let data = image.pngData() else {
            return nil
        }
        let fileURL = self.fileURLInDocumentDirectory(fileName)
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            return nil
        }
    }
  */
    func loadImage(url: URL)// -> UIImage
    {
        //let url = URL(string: url)
        var image = UIImage(named: "")
        //DispatchQueue.global().async
           //{
            let data = try? Data(contentsOf: url) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            //DispatchQueue.main.async
            //{
                //imageView.image =
                image = UIImage(data: data!)
                tempImage = image
                //return UIImage(data: data!)
            //}
        //}
        //return image
    }

    
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func saveImage(image: UIImage, name: String) -> Bool
    {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else
        {
            print("false 1")
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else
        {
            print("false 2")
            return false
        }
        do
        {
            try data.write(to: directory.appendingPathComponent(name + ".png")!)
            print("saved")
            return true
        }
        catch
        {
            print(error.localizedDescription)
            return false
        }
    }
    
    @objc func addButtonTapped()
    {
        navigationItem.setRightBarButton(nil, animated: false)
        navigationItem.rightBarButtonItem = removeButton
        var favoriteFilm = Film()
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // choose a name for your image
        let fileName = String(myIndex) + ".jpg"
        //let fileName = topRatedFilms[myIndex].title + ".jpg"
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        print("FULE URL = \(fileURL)")
        // get your UIImage jpeg data representation and check if the destination file url already exists
        if let data = tempImage?.jpegData(compressionQuality: 1.0),
            !FileManager.default.fileExists(atPath: fileURL.path)
        {
            do
            {
                // writes the image data to disk
                try data.write(to: fileURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
        
        //if let imageData = tempImage!.pngData()
        //{
        //    let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        //    let imageURL = docDir.appendingPathComponent("tmp.png")
        //    try! imageData.write(to: imageURL)
        //}

        //if let imageToSave = tempImage
        //{
        //    let success = saveImage(image: imageToSave, name: topRatedFilms[myIndex].title)
        //    print("success = \(success)")
        //}
        
        //let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        //let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        //let filePath = "\(paths[0])/\(topRatedFilms[myIndex].title).png"
        //if let image = imageToSave
        //{
        //    if let data = image.pngData()
        //    {
        //        let filename = getDocumentsDirectory().appendingPathComponent("\(topRatedFilms[myIndex].title).png")
        //        try? data.write(to: filename)
        //        print(filename)
        //    }
        //}
        // Save image.
        //try! imageToSave?.pngData()?.write(to: URL(fileURLWithPath: filePath))
        //print("path to image = \(filePath)")
        //UIImagePNGRepresentation(imageToSave)?.writeToFile(filePath, atomically: true)
        //let destinationPath = documentsPath.stringByAppendingPathComponent("filename.jpg")
        //UIImageJPEGRepresentation(image,1.0).writeToFile(destinationPath, atomically: true)
        favoriteFilm = favoriteFilm.createFilm(poster: fileURL.relativeString, title: topRatedFilms[myIndex].title, rate: topRatedFilms[myIndex].rate, overview: topRatedFilms[myIndex].overwiev)
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
