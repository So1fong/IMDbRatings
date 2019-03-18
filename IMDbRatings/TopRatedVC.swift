//
//  TopRatedVC.swift
//  IMDbRatings
//
//  Created by Ekaterina Kozlova on 18.03.2019.
//  Copyright © 2019 Ekaterina Kozlova. All rights reserved.
//

import UIKit
import RxSwift

let request: IMDbRequest = IMDbRequest()

class TopRatedVC: UIViewController
{
    @IBOutlet weak var topRatedTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        request.topRatedRequest(page: 1)
    }
    


}
