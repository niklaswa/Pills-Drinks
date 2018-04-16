//
//  Constants.swift
//  Pills & Drinks
//
//  Created by Niklas on 06.04.18.
//  Copyright © 2018 Niklas. All rights reserved.
//

import Foundation

var drinks:[drink]?

func saveDrinkData(_ :[drink]) {
    print("Try to safe drinkData....")
    print(drinks!)
    //if drinks != nil, drinks!.count > 0 {
    //    let encodedData = NSKeyedArchiver.archivedData(withRootObject: drinks ?? [drink]())
    //    UserDefaults.standard.set(encodedData, forKey: "data")
    //}
}

func fetchDrinkData() -> [drink]? {
    return nil
}


func getDrinkTypeNiceName(type: drinkType) -> String {
    switch type {
    case .water:
        return "Wasser"
    case .coke:
        return "Cola"
    case .speci:
        return "Spezi"
    }
}

class drink: NSObject {
    var name: String = ""
    var type: drinkType = .water
    var amount: Int = 200 // in Milliliter
}

enum drinkType {
    case water
    case coke
    case speci
}
