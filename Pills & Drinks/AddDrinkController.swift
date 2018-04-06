//
//  AddDrink.swift
//  Pills & Drinks
//
//  Created by Niklas on 06.04.18.
//  Copyright © 2018 Niklas. All rights reserved.
//

import UIKit
import TapticEngine

class AddDrinkController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    
    @IBAction func addDrinkPressed(_ sender: UIButton) {
        
        if (nameField.text != nil) && nameField.text != "" {
            let newDrink: drink = drink(name: nameField.text!, type: drinkType.water, amount: 200)
            drinks?.append(newDrink)
            TapticEngine.notification.feedback(.success)
            nameField.placeholder = "Name"
            nameField.text = ""
            performSegueToReturnBack()
        } else {
            TapticEngine.notification.feedback(.error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
}
