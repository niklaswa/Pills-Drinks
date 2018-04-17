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
    
    init(name: String) {
        super.init(name: name, category: .pill)
    }
    
    override func calculateHealthData() -> [HKQuantityTypeIdentifier: Double] {
        var thingsToAdd = [HKQuantityTypeIdentifier: Double]()
            
        thingsToAdd[HKQuantityTypeIdentifier.dietaryWater] = 20
        thingsToAdd[HKQuantityTypeIdentifier.dietaryZinc] = 20
        thingsToAdd[HKQuantityTypeIdentifier.dietaryEnergyConsumed] = 100
            
        return thingsToAdd
    }
}
