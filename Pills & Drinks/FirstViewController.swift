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

    private var h = Health()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
         super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func addItem(currentItem: HealthItem) {
        let data = currentItem.calculateHealthData()
        if !h.checkHealthRights(thingsToAdd: data) {
            print("Doesn't have all the rights to write the data")
            let alert = UIAlertController(title: "Health Zugriff verweigert", message: "Der Zugriff auf Health wurde verweigert. Bitte lasse den Zugriff im folgenden Dialog zu und versuche es erneut.", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Zugriff gewähren", style: .default, handler:
                {(alert: UIAlertAction!) in
                    self.h.authorizeHealthAccess(thingsToAdd: data, callback: { (success) in
                        if success {
                            if !self.h.addThingsToHealth(thingsToAdd: data, item: currentItem) {
                                TapticEngine.notification.feedback(.error)
                            }
                            TapticEngine.notification.feedback(.success)
                        } else {
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
                    })
            }
            ))
            alert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler:
                {(alert: UIAlertAction!) in TapticEngine.notification.feedback(.error) }
            ))
            
            self.present(alert, animated: true)
        } else {
            print("It has all the rights to write the data yay")
            if !h.addThingsToHealth(thingsToAdd: data, item: currentItem) {
                TapticEngine.notification.feedback(.error)
            }
            self.view.makeToast("\(currentItem.name) erfolgreich zu Health hinzugefügt")
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
        let currentItem = items![indexPath.row]
        
        dialog = ZAlertView(
            title: "Hinzufügen?",
            message: "\(currentItem.name) wirklich zu Health hinzufügen?",
            isOkButtonLeft: false,
            okButtonText: "Ja!",
            cancelButtonText: "Abbrechen",
            okButtonHandler: {(sender: ZAlertView) in
                self.addItem(currentItem: currentItem); self.dialog.dismissAlertView()
            },
            cancelButtonHandler: {(sender: ZAlertView) in
                self.dialog.dismissAlertView()
            }
        )
        dialog.show()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let itemData = items {
            return itemData.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        if let itemData = items {
            cell.textLabel?.text = itemData[indexPath.row].name
            cell.detailTextLabel?.text = itemData[indexPath.row].getMetaData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items?.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}

