//
//  Drink.swift
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
    var type: DrinkType = .water
    var amount: NSInteger = 200 //ml
    
    init(name: String) {
        super.init(name: name, category: .drink)
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.name = decoder.decodeObject(forKey: "name") as? String ?? ""
        self.category = ItemCategory(rawValue: (decoder.decodeObject(forKey: "category") as! String)) ?? .drink
        self.type = DrinkType(rawValue: (decoder.decodeObject(forKey: "type") as! String)) ?? .water
        self.amount = decoder.decodeObject(forKey: "amount") as? Int ?? 0
    }
    
    override func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.category.rawValue, forKey: "category")
        coder.encode(self.type.rawValue, forKey: "type")
        coder.encode(self.amount, forKey: "amount")
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

enum DrinkType : String {
    case water = "Wasser"
    case coke  = "Cola"
    case speci = "Spezi"
}
