//
//  FirstViewController.swift
//  Pills & Drinks
//
//  Created by Niklas on 05.04.18.
//  Copyright © 2018 Niklas. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var drinkTableView: UITableView!
    
    override func viewDidLoad() {
         super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        drinkTableView.delegate = self
        drinkTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        drinkTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let drinkData = drinks {
            return drinkData.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        if let drinkData = drinks {
            cell.textLabel?.text = drinkData[indexPath.row].name
            cell.detailTextLabel?.text = String(drinkData[indexPath.row].amount) + "ml"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            drinks?.remove(at: indexPath.row)
            drinkTableView.reloadData()
        }
    }
}

