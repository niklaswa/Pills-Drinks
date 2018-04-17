//
//  HealthItem.swift
//  Pills & Drinks
//
//  Created by Niklas on 16.04.18.
//  Copyright © 2018 Niklas. All rights reserved.
//

import Foundation
import HealthKit

class HealthItem {
    var name: String
    var category: ItemCategory
    init(name: String, category: ItemCategory) {
        self.name = name
        self.category = category
    }
    
    func getMetaData() -> String {
        return "\(self.name)"
    }
    
    func calculateHealthData() -> [HKQuantityTypeIdentifier: Double] {
        return [HKQuantityTypeIdentifier: Double]()
    }
}

enum ItemCategory: String {
    case drink
    case pill
}
