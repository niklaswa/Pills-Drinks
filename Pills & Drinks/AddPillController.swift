//
//  AddPillController.swift
//  Pills & Drinks
//
//  Created by Niklas on 17.04.18.
//  Copyright © 2018 Niklas. All rights reserved.
//

import UIKit
import TapticEngine

class AddPillController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    @IBAction func addPillPressed(_ sender: UIButton) {
        if (nameField.text != nil) && nameField.text != "" {
            let newPill = Pill(name: nameField.text!)
            items?.append(newPill)
            TapticEngine.notification.feedback(.success)
            nameField.placeholder = "Name"
            nameField.text = ""
            performSegueToReturnBack()
            self.tabBarController?.tabBar.isHidden = false
        } else {
            TapticEngine.notification.feedback(.error)
        }
    }
    
   
}
