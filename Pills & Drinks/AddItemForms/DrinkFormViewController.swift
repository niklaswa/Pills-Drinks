//
//  DrinkFormViewController.swift
//  Pills & Drinks
//
//  Created by Niklas on 19.04.18.
//  Copyright © 2018 Niklas. All rights reserved.
//

import UIKit
import TapticEngine
import Eureka

class DrinkFormViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        
        form +++ Section("Name")
            <<< TextRow(){ row in
                row.tag = "drinkName"
                row.title = "Name"
                row.placeholder = "Name des Getränks"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                
            }
            +++ Section("Eigenschaften")
            <<< AlertRow<DrinkType>(){
                $0.tag = "drinkType"
                $0.title = "Getränketyp"
                $0.options = DrinkType.allValues
                $0.add(rule: RuleRequired())
                $0.value = .water
                $0.validationOptions = .validatesOnChangeAfterBlurred
                $0.displayValueFor = { (rowValue: DrinkType?) in
                    return getDrinkTypeNiceName(rowValue!)
                }
            }
            <<< IntRow() {
                $0.tag = "drinkAmount"
                $0.title = "Menge"
                $0.value = 200
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleGreaterThan(min: 10))
                $0.add(rule: RuleSmallerThan(max: 1501))
                let formatter = NumberFormatter()
                formatter.positiveSuffix = "ml"
                $0.formatter = formatter
                $0.validationOptions = .validatesOnChangeAfterBlurred
            }
            <<< ButtonRow() {
                $0.title = "Hinzufügen"
                $0.onCellSelection(self.buttonTapped)
            }
    }
    
    func buttonTapped(cell: ButtonCellOf<String>, row: ButtonRow) {
        addDrink()
        print("tapped!")
    }
    
    private func addDrink() {
        let nameRow: TextRow? = form.rowBy(tag: "drinkName")
        let name = nameRow?.value
        let typeRow: BaseRow? = form.rowBy(tag: "drinkType")
        let type = typeRow?.baseValue
        let amountRow: IntRow? = form.rowBy(tag: "drinkAmount")
        let amount = amountRow?.value
        
        if let name = name, name != "" {
            let newDrink = Drink(name: name)
            newDrink.type = type as! DrinkType
            newDrink.amount = amount!
            items?.append(newDrink)
            TapticEngine.notification.feedback(.success)
            performSegueToReturnBack()
            self.tabBarController?.tabBar.isHidden = false
        } else {
            TapticEngine.notification.feedback(.error)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
}
