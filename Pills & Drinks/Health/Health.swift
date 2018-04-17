//
//  Health.swift
//  Pills & Drinks
//
//  Created by Niklas on 05.04.18.
//  Copyright © 2018 Niklas. All rights reserved.
//

import Foundation
import HealthKit
import TapticEngine

let healthKitStore:HKHealthStore = HKHealthStore()

let healtKitTypesToRead : Set<HKObjectType> = [
    HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!,
    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!,
    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine)!
]

let healtKitTypesToWrite : Set<HKSampleType> = [
    HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!,
    HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine)!,
    HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryVitaminB12)!,
    HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryZinc)!,
    HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!,
    HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryVitaminC)!,
    HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryBiotin)!,
    HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)!,
    HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFiber)!,
    HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFolate)!,
    HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryNiacin)!,
    HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryPantothenicAcid)!,
    HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryThiamin)!,
    HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryVitaminB6)!,
    HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatTotal)!
]

class Health {
    var healthKitTypesToWriteNow : Set<HKSampleType> = []
    
    func checkHealthRights(thingsToAdd: [HKQuantityTypeIdentifier: Double]) -> Bool {
        healthKitTypesToWriteNow = []
        for element in thingsToAdd {
            if !checkHealthAccess(identifier: element.key) {
                healthKitTypesToWriteNow.insert(HKSampleType.quantityType(forIdentifier: element.key)!)
            }
        }
        if healthKitTypesToWriteNow.count > 0 {
            return false
        }
        return true
    }
    
    func authorizeHealthAccess(thingsToAdd: [HKQuantityTypeIdentifier: Double], callback: @escaping (Bool) -> Void) -> Void {
        for element in thingsToAdd {
            switch healthKitStore.authorizationStatus(for: HKSampleType.quantityType(forIdentifier: element.key)!) {
            case .notDetermined:
                healthKitTypesToWriteNow.insert(HKSampleType.quantityType(forIdentifier: element.key)!)
                break
            case .sharingDenied:
                callback(false)
                return
            case .sharingAuthorized:
                break
            }
        }
        if healthKitTypesToWriteNow.count > 0 {
            healthKitStore.requestAuthorization(toShare: healthKitTypesToWriteNow, read: []) {
                (success, error) -> Void in
                callback(success)
            }
        } else {
            callback(true)
        }
    }
    
    func addThingsToHealth(thingsToAdd: [HKQuantityTypeIdentifier: Double], item: HealthItem) -> Bool {
        for element in thingsToAdd {
            if !addThingToHealth(thing: element.key, amount: element.value, item: item) {
                return false
            }
        }
        return true
    }
    
    func addThingToHealth(thing: HKQuantityTypeIdentifier, amount: Double, item: HealthItem) -> Bool {
        if checkHealthAccess(identifier: thing) {
            guard let type = HKQuantityType.quantityType(forIdentifier: thing) else {
                fatalError("\(thing) is no longer available in HealthKit")
            }
            //2.  Use the Count HKUnit to create a quantity
            let quantity : HKQuantity
            switch thing {
            case HKQuantityTypeIdentifier.dietaryWater:
                quantity = HKQuantity(unit: HKUnit.literUnit(with: .milli), doubleValue: amount)
            case HKQuantityTypeIdentifier.dietaryCaffeine:
                quantity = HKQuantity(unit: HKUnit.gramUnit(with: .milli), doubleValue: amount)
            case HKQuantityTypeIdentifier.dietaryEnergyConsumed:
                quantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: amount)
            default:
                quantity = HKQuantity(unit: HKUnit.gramUnit(with: .milli), doubleValue: amount)
            }
            
            let metadata = [HKMetadataKeyFoodType: item.getMetaData()]
            
            let sample = HKQuantitySample(type: type, quantity: quantity, start: Date(), end: Date(), metadata: metadata)
            //3.  Save to HealthKit
            HKHealthStore().save(sample) { (success, error) in
                if let error = error {
                    print("Error Saving: \(error.localizedDescription)")
                } else {
                    print("Successfully saved")
                }
            }
            return true
        } else {
            print("No access!")
            return false
        }
    }
    
    func checkHealthAccess(identifier: HKQuantityTypeIdentifier) -> Bool {
        switch healthKitStore.authorizationStatus(for: HKSampleType.quantityType(forIdentifier: identifier)!) {
        case .sharingAuthorized:
            print("\(identifier) sharingAuthorized")
            return true
        case .notDetermined:
            print("\(identifier) notDetermined")
            return false
        case .sharingDenied:
            print("\(identifier) sharingDenied -> Need to be activated manually by the user in the Health App")
            return false
        }
    }
}
