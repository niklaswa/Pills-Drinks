//
//  Constants.swift
//  Pills & Drinks
//
//  Created by Niklas on 06.04.18.
//  Copyright © 2018 Niklas. All rights reserved.
//

import Foundation

var drinks:[drink]?

func saveDrinkData(drinks:[drink]) {
    UserDefaults.standard.set(drinks, forKey: "drinks")
}

func fetchDrinkData() ->[drink]? {
    if let drinkData = UserDefaults.standard.array(forKey: "drinks") as? [drink] {
        return drinkData
    } else {
        return nil
    }
}

struct drink {
    var name: String
    var type: drinkType
    var amount: Int // in Milliliter
}

enum drinkType {
    case water
    case coke
    case speci
}
