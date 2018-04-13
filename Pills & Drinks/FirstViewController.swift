//
//  FirstViewController.swift
//  Pills & Drinks
//
//  Created by Niklas on 05.04.18.
//  Copyright © 2018 Niklas. All rights reserved.
//

import UIKit
import TapticEngine
import ZAlertView
import Toast_Swift
import SAConfettiView

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
    
    func addDrink(currentDrink: drink) {
        let data = d.calculateHealthData(drink: currentDrink)
        if !h.checkHealthRights(thingsToAdd: data) {
            print("Don't has all the rights to write the data")
            let alert = UIAlertController(title: "Health Zugriff verweigert", message: "Der Zugriff auf Health wurde verweigert. Bitte lasse den Zugriff im folgenden Dialog zu und versuche es erneut.", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Zugriff gewähren", style: .default, handler:
                {(alert: UIAlertAction!) in
                    if self.h.authorizeHealthAccess(thingsToAdd: data) {
                        if !self.h.addThingsToHealth(thingsToAdd: data, drink: currentDrink) {
                            TapticEngine.notification.feedback(.error)
                        }
                        TapticEngine.notification.feedback(.success)
                    } else {
                        // TODO: Der folgende Code muss in den Callback von authorizeHealthAccess (Callback von healthKitStore.requestAuthorization, da er im Moment immer ausgeführt wird, obwohl der User gar nicht explizit verweigert hat, sondern nur noch nie zugestimmt hat
                        let deniedAlert = UIAlertController(title: "Health Zugriff verweigert", message: "Zugriff auf Health wurde explizit verweigert. Bitte erlauben Sie den Zugriff in den Quellen in der Health-App.", preferredStyle: .alert)
                        deniedAlert.addAction(UIAlertAction(title: "Zu Health wechseln", style: .default, handler:
                            {(alert: UIAlertAction!) in
                                let healthUrl = URL(string: "x-apple-health://")
                                if UIApplication.shared.canOpenURL(healthUrl!) {
                                    UIApplication.shared.open(healthUrl!, options: [:], completionHandler: nil)
                                }
                        }))
                        deniedAlert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel))
                        self.present(deniedAlert, animated: true)
                    }
                }
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
            self.view.makeToast("\(currentDrink.name) erfolgreich zu Health hinzugefügt")
            TapticEngine.notification.feedback(.success)
            
            let confettiView = SAConfettiView(frame: self.view.bounds)
            self.view.addSubview(confettiView)
            confettiView.startConfetti()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                confettiView.stopConfetti()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.9) {
                    confettiView.removeFromSuperview()
                }
            }
            
        }
    }
    
    var dialog: ZAlertView = ZAlertView()

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentDrink = drinks![indexPath.row]
        
        dialog = ZAlertView(
            title: "Hinzufügen?",
            message: "\(currentDrink.name) wirklich hinzufügen?",
            isOkButtonLeft: false,
            okButtonText: "Ja!",
            cancelButtonText: "Abbrechen",
            okButtonHandler: {(sender: ZAlertView) in
                self.addDrink(currentDrink: currentDrink); self.dialog.dismissAlertView()
            },
            cancelButtonHandler: {(sender: ZAlertView) in
                self.dialog.dismissAlertView()
            }
        )
        dialog.show()
        
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

