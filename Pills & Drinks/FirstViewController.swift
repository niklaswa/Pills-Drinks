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
import WatchConnectivity

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, WCSessionDelegate {

    private var h = Health()
    private var tableEntries: [HealthItem]?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigation: UINavigationBar!
    @IBOutlet weak var tabBar: UITabBar!
    
    override func viewDidLoad() {
         super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tabBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch tabBarController?.selectedIndex {
        case 1:
            tableEntries = items?.filter { $0.category == .pill }
        default:
            tableEntries = items?.filter { $0.category == .drink }
        }
        
        tableView.reloadData()
    }
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        switch tabBarController!.selectedIndex {
        case 1:
            self.performSegue(withIdentifier: "AddPillSegue", sender: self)
        default:
            self.performSegue(withIdentifier: "AddDrinkSegue", sender: self)
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch tabBar.selectedItem?.title {
        case "Pillen und Medikamente":
            tableEntries = items?.filter { $0.category == .pill }
            navigation.topItem!.title = "Pillen und Medikamente"
            print("Pillen und Medikamente")
        default:
            tableEntries = items?.filter { $0.category == .drink }
            navigation.topItem!.title = "Getränke"
            print("Getränke")
        }
        tableView.reloadData()
        print("Current title: \(navigation.topItem?.title!)")
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
                            self.addingEffect(with: currentItem)
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
            self.addingEffect(with: currentItem)
        }
    }
    
    func addingEffect(with item: HealthItem) {
        
        if (WCSession.default.isReachable) {
            // this is a meaningless message, but it's enough for our purposes
            let message = ["Message": "Hello"]
            WCSession.default.sendMessage(message, replyHandler: nil)
        }
        self.view.makeToast("\(item.name) erfolgreich zu Health hinzugefügt")
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
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}
