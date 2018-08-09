//
//  HomeViewController.swift
//  NYTimes
//
//  Created by Fingent on 08/08/18.
//  Copyright © 2018 fingent. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    var presenter:HomeViewPresenter?
    @IBOutlet weak var newsFeedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    func getNYTNewsFeed(){
        presenter = HomeViewPresenter()
        presenter
    }

}
