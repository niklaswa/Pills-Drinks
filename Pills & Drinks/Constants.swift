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
    if drinks != nil, drinks!.count > 0 {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: drinks ?? [drink]())
        UserDefaults.standard.set(encodedData, forKey: "data")
    }
}

func fetchDrinkData() -> [drink]? {
    if let data = UserDefaults.standard.data(forKey: "data"),
        let drinkData = NSKeyedUnarchiver.unarchiveObject(with: data) as? [drink] {
        return drinkData
    } else {
        return nil
    }
}


private func archiveDrink(archivedObject: [drink]) -> NSData {
    return NSKeyedArchiver.archivedData(withRootObject: drinks! as NSArray) as NSData
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

class drink: NSObject, NSCoding {
    var name: String
    var type: String
    var amount: Int // in Milliliter
    init(name: String, type: String, amount: Int) {
        self.name = name
        self.type = type
        self.amount = amount
    }
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObject(forKey: "name") as? String ?? ""
        self.type = decoder.decodeObject(forKey: "type") as? String ?? ""
        self.amount = decoder.decodeInteger(forKey: "amount")
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(type, forKey: "type")
        coder.encode(amount, forKey: "amount")
    }
}

enum drinkType {
    case water
    case coke
    case speci
}
