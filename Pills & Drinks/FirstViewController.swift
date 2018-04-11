//
//  FirstViewController.swift
//  Pills & Drinks
//
//  Created by Niklas on 05.04.18.
//  Copyright © 2018 Niklas. All rights reserved.
//

import UIKit
import TapticEngine

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var d = Drinks()
    private var h = Health()
    
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = d.calculateHealthData(drink: drinks![indexPath.row])
        let currentDrink = drinks![indexPath.row]
        if !h.checkHealthRights(thingsToAdd: data) {
            print("Don't has all the rights to write the data")
            let alert = UIAlertController(title: "Health Zugriff verweigert", message: "Der Zugriff auf Health wurde verweigert. Bitte lasse den Zugriff im folgenden Dialog zu und versuche es erneut.", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Zugriff gewähren", style: .default, handler:
                {(alert: UIAlertAction!) in if self.h.authorizeHealthAcces(thingsToAdd: data) {
                        if !self.h.addThingsToHealth(thingsToAdd: data, drink: currentDrink) {
                            TapticEngine.notification.feedback(.error)
                        }
                        TapticEngine.notification.feedback(.success)
                    } }
                // Rekursion?
            ))
            alert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler:
            {(alert: UIAlertAction!) in TapticEngine.notification.feedback(.error) }
            ))
            
            self.present(alert, animated: true)
        } else {
            print("It has all the rights to write the data yay")
            if !h.addThingsToHealth(thingsToAdd: data, drink: currentDrink) {
                TapticEngine.notification.feedback(.error)
            }
            TapticEngine.notification.feedback(.success)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let drinkData = drinks {
            return drinkData.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        if let drinkData = drinks {
            cell.textLabel?.text = drinkData[indexPath.row].name
            cell.detailTextLabel?.text = String(drinkData[indexPath.row].amount) + "ml " + drinkData[indexPath.row].type
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

