//
//  HealthItem.swift
//  Pills & Drinks
//
//  Created by Niklas on 16.04.18.
//  Copyright © 2018 Niklas. All rights reserved.
//

import Foundation
import HealthKit

class HealthItem: NSObject, NSCoding {
    var name: String
    var category: ItemCategory
    init(name: String, category: ItemCategory) {
        self.name = name
        self.category = category
    }
    
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObject(forKey: "name") as? String ?? ""
        self.category = ItemCategory(rawValue: (decoder.decodeObject(forKey: "category") as! String)) ?? .drink
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.category.rawValue, forKey: "category")
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
