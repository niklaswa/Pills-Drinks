//
//  Constants.swift
//  Pills & Drinks
//
//  Created by Niklas on 06.04.18.
//  Copyright © 2018 Niklas. All rights reserved.
//

import Foundation

var items:[HealthItem]?

func saveItems() {
    print("Try to safe HealthItems....")
    print(items!)
    if let items = items, items.count > 0 {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: items)
        UserDefaults.standard.set(encodedData, forKey: "data")
    }
}

func fetchItems() -> [HealthItem]? {
    if let data = UserDefaults.standard.data(forKey: "data"),
        let drinkData = NSKeyedUnarchiver.unarchiveObject(with: data) as? [HealthItem] {
        return drinkData
    } else {
        return nil
    }
}


