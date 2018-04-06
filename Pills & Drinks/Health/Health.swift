//
//  Health.swift
//  Pills & Drinks
//
//  Created by Niklas on 05.04.18.
//  Copyright © 2018 Niklas. All rights reserved.
//

import Foundation
import HealthKit

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
    func checkHealthAccess() -> Bool {
        healthKitStore.authorizationStatus(for: HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatTotal)!)
        return false
    }
    
    func authorizeHealthKit() -> Bool {
        if !HKHealthStore.isHealthDataAvailable() {
            print("Error (isHealthDataAvailable() -> False)")
            return false
        }
        
        healthKitStore.requestAuthorization(toShare: healtKitTypesToWrite, read: healtKitTypesToRead) {
            (success, error) -> Void in
            print("Read Auth success")
        }
        return true
    }
}
