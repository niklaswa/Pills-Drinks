//
//  Drinks.swift
//  Pills & Drinks
//
//  Created by Niklas on 05.04.18.
//  Copyright © 2018 Niklas. All rights reserved.
//
// Caffeine: https://www.caffeineinformer.com/caffeine-amounts-in-soda-every-kind-of-cola-you-can-think-of
//           https://www.coca-cola-deutschland.de/stories/wie-viel-koffein-ist-in-coca-cola-enthalten
// Water:    https://www.quora.com/Beverages-What-percentage-of-Coca-Cola-is-water

import Foundation
import HealthKit

class Drink: HealthItem {
    var type: drinkType = .water
    var amount: Int = 200 //ml
    
    init(name: String) {
        super.init(name: name, category: .drink)
    }
    
    override func getMetaData() -> String {
        return "\(self.amount)ml \(self.getDrinkTypeNiceName())"
    }
    
    func getDrinkTypeNiceName() -> String {
        switch self.type {
        case .water:
            return "Wasser"
        case .coke:
            return "Cola"
        case .speci:
            return "Spezi"
        }
    }
    
    override func calculateHealthData() -> [HKQuantityTypeIdentifier: Double] {
        let amount = Double(self.amount)
        var thingsToAdd = [HKQuantityTypeIdentifier: Double]()
        
        switch self.type {
        case .water:
            thingsToAdd[HKQuantityTypeIdentifier.dietaryWater] = amount
        case .coke:
            thingsToAdd[HKQuantityTypeIdentifier.dietaryWater] = amount * 0.89
            thingsToAdd[HKQuantityTypeIdentifier.dietaryCaffeine] = amount * 0.1
        case .speci:
            thingsToAdd[HKQuantityTypeIdentifier.dietaryWater] = amount * 0.90
            thingsToAdd[HKQuantityTypeIdentifier.dietaryCaffeine] = amount * 0.06
            thingsToAdd[HKQuantityTypeIdentifier.dietaryEnergyConsumed] = amount * 0.43
        }
        return thingsToAdd
    }
}

enum drinkType {
    case water
    case coke
    case speci
}
