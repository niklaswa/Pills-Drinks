//
//  Pill.swift
//  Pills & Drinks
//
//  Created by Niklas on 17.04.18.
//  Copyright © 2018 Niklas. All rights reserved.
//

import Foundation
import HealthKit

class Pill: HealthItem {
    var content = [HKQuantityTypeIdentifier: Int]()
    
    init(name: String) {
        super.init(name: name, category: .pill)
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.name = decoder.decodeObject(forKey: "name") as? String ?? ""
        self.category = ItemCategory(rawValue: (decoder.decodeObject(forKey: "category") as! String)) ?? .drink
        self.content = decoder.decodeObject(forKey: "content") as? [HKQuantityTypeIdentifier: Int] ?? [:]
    }
    
    override func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.category.rawValue, forKey: "category")
        coder.encode(self.category.rawValue, forKey: "category")
        coder.encode(self.content, forKey: "content")
    }

    override func calculateHealthData() -> [HKQuantityTypeIdentifier: Double] {
        var thingsToAdd = [HKQuantityTypeIdentifier: Double]()
        
        for item in content {
            thingsToAdd[item.key] = Double(item.value)
        }
        
        return thingsToAdd
    }
}

let availablePillTypes = [
    HKQuantityTypeIdentifier.dietaryWater,
    HKQuantityTypeIdentifier.dietaryZinc,
    HKQuantityTypeIdentifier.dietaryBiotin,
    HKQuantityTypeIdentifier.dietaryFolate,
    HKQuantityTypeIdentifier.dietaryEnergyConsumed,
    HKQuantityTypeIdentifier.dietaryNiacin,
    HKQuantityTypeIdentifier.dietaryPantothenicAcid,
    HKQuantityTypeIdentifier.dietaryProtein,
    HKQuantityTypeIdentifier.dietaryRiboflavin,
    HKQuantityTypeIdentifier.dietaryThiamin,
    HKQuantityTypeIdentifier.dietaryVitaminB6,
    HKQuantityTypeIdentifier.dietaryVitaminC,
    HKQuantityTypeIdentifier.dietaryChloride,
    HKQuantityTypeIdentifier.dietaryIron,
    HKQuantityTypeIdentifier.dietaryIodine,
    HKQuantityTypeIdentifier.dietaryMagnesium,
    HKQuantityTypeIdentifier.dietaryCopper,
    HKQuantityTypeIdentifier.dietaryVitaminA,
    HKQuantityTypeIdentifier.dietaryVitaminD,
    HKQuantityTypeIdentifier.dietaryVitaminE,
    HKQuantityTypeIdentifier.dietaryVitaminK
]

func getHKIdentifierNiceName(from: HKQuantityTypeIdentifier?) -> String {
    print(from)
    if let id = from {
        switch id {
        case HKQuantityTypeIdentifier.dietaryWater:
            return "Wasser"
        case HKQuantityTypeIdentifier.dietaryVitaminD:
            return "Vitamin D"
        case HKQuantityTypeIdentifier.dietaryVitaminA:
            return "Vitamin A"
        case HKQuantityTypeIdentifier.dietaryZinc:
            return "Zink"
        case HKQuantityTypeIdentifier.dietaryBiotin:
            return "Biotin"
        case HKQuantityTypeIdentifier.dietaryVitaminA:
            return "Vitamin A"
        case HKQuantityTypeIdentifier.dietaryFolate:
            return "Folat"
        case HKQuantityTypeIdentifier.dietaryEnergyConsumed:
            return "Kilokalorien"
        case HKQuantityTypeIdentifier.dietaryNiacin:
            return "Niacin"
        case HKQuantityTypeIdentifier.dietaryPantothenicAcid:
            return "Pantothensäure"
        case HKQuantityTypeIdentifier.dietaryProtein:
            return "Protein"
        case HKQuantityTypeIdentifier.dietaryRiboflavin:
            return "Riboflavin"
        case HKQuantityTypeIdentifier.dietaryThiamin:
            return "Thiamin"
        case HKQuantityTypeIdentifier.dietaryVitaminB6:
            return "Vitamin B6"
        case HKQuantityTypeIdentifier.dietaryVitaminC:
            return "Vitamin C"
        case HKQuantityTypeIdentifier.dietaryChloride:
            return "Chlorid"
        case HKQuantityTypeIdentifier.dietaryIron:
            return "Eisen"
        case HKQuantityTypeIdentifier.dietaryIodine:
            return "Jod"
        case HKQuantityTypeIdentifier.dietaryMagnesium:
            return "Magnesium"
        case HKQuantityTypeIdentifier.dietaryCopper:
            return "Kupfer"
        case HKQuantityTypeIdentifier.dietaryVitaminE:
            return "Vitamin E"
        case HKQuantityTypeIdentifier.dietaryVitaminK:
            return "Vitamin K"
        default:
            return "Not implemented"
        }
    }
    return "Not implemented"
}
