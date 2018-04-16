//
//  AddDrink.swift
//  Pills & Drinks
//
//  Created by Niklas on 06.04.18.
//  Copyright © 2018 Niklas. All rights reserved.
//

import UIKit
import TapticEngine

class AddDrinkController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return drinkTypes.count
    }
    
    @IBOutlet weak var nameField: UITextField!
    
    var drinkTypes = [String]()
    var selectedDrinkType = drinkType.water
    @IBOutlet weak var typeField: UIPickerView!
    
    @IBOutlet weak var amountSlider: UISlider!
    @IBOutlet weak var sliderValueLabel: UILabel!
    private var amount = 500
    
    @IBAction func amountSliderChanged(_ sender: UISlider) {
        sender.setValue(50 * floor((sender.value/50)+0.5), animated: true)
        if Int(sender.value) % 50 == 0, Int(sender.value) != amount {
            amount = Int(sender.value)
            sliderValueLabel.text = String(amount) + " ml"
            TapticEngine.impact.feedback(.light)
        }
    }
    
    @IBAction func addDrinkPressed(_ sender: UIButton) {
        if (nameField.text != nil) && nameField.text != "" {
            let newDrink = drink()
            newDrink.amount = amount
            newDrink.type = selectedDrinkType
            newDrink.name = nameField.text!
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
        
        drinkTypes = ["water","coke","speci"]
        
        self.typeField.dataSource = self;
        self.typeField.delegate = self;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return drinkTypes[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch drinkTypes[row] {
        case "water":
            selectedDrinkType = drinkType.water
        case "coke":
            selectedDrinkType = drinkType.coke
        case "speci":
            selectedDrinkType = drinkType.speci
        default:
            selectedDrinkType = drinkType.water
        }
    }
    
}
