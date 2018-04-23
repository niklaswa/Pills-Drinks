//
//  PillFormViewController.swift
//  Pills & Drinks
//
//  Created by Niklas on 20.04.18.
//  Copyright © 2018 Niklas. All rights reserved.
//

import UIKit
import TapticEngine
import Eureka
import SplitRow
import HealthKit

class PillFormViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        form +++ Section("Name")
            <<< TextRow(){ row in
                row.tag = "name"
                row.title = "Name"
                row.placeholder = "Name der Pille"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
            }
            +++ MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                   header: "Inhaltsstoffe") {
                    $0.tag = "test"
                    $0.addButtonProvider = { section in
                        return ButtonRow(){
                            $0.title = "Neuen Inhaltsstoff hinzufügen"
                        }
                    }
                    $0.multivaluedRowToInsertAt = { index in
                        return SplitRow<AlertRow<HKQuantityTypeIdentifier>,IntRow>(){
                            $0.rowLeft = AlertRow<HKQuantityTypeIdentifier>(){
                                $0.tag = "type_\(index+1)"
                                $0.options = availablePillTypes
                                $0.displayValueFor = { (rowValue: HKQuantityTypeIdentifier?) in
                                    if let value = rowValue {
                                        return getHKIdentifierNiceName(from: value)
                                    }
                                    return ""
                                }
                            }
                            $0.rowRight = IntRow() {
                                $0.tag = "amount_\(index+1)"
                                $0.title = "Menge"
                                $0.add(rule: RuleGreaterThan(min: 1))
                                $0.add(rule: RuleSmallerThan(max: 1501))
                                let formatter = NumberFormatter()
                                formatter.positiveSuffix = "mg"
                                $0.formatter = formatter
                            }
                        }
                    }
            }
            +++ Section("Jo")
            <<< ButtonRow() {
                $0.title = "Hinzufügen"
                $0.onCellSelection(self.buttonTapped)
            }
    }
    
    func buttonTapped(cell: ButtonCellOf<String>, row: ButtonRow) {
        add()
        print("tapped!")
    }
    
    private func add() {
        let nameRow: TextRow? = form.rowBy(tag: "name")
        let name = nameRow?.value
        
        let values = form.values()
        
        print(values)
        
        // SplitRow.SplitRowValue<__C.HKQuantityTypeIdentifier, Swift.Int>
//        if let content = values["content"] {
//            print(content)
//            let data = content as! [SplitRowValue<HKQuantityTypeIdentifier, Swift.Int>?]
//            for item in data {
//                print(item)
//                print("\n")
//                if let left = item?.left!, let right = item?.right! {
//                    //print(left)
//                    //print(right)
//                }
//            }
//        }
        
        
        //for item in content {
        //    print(item!)
        //}
        
        if let name = name, name != "" {
            let newPill = Pill(name: name)
            
            print()
            
            items?.append(newPill)
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
