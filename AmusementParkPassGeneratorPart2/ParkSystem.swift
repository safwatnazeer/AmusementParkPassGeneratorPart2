//
//  ParkSystem.swift
//  AmuesmentParkPassGenerator
//
//  Created by Safwat Shenouda on 24/09/16.
//  Copyright © 2016 Safwat Shenouda. All rights reserved.
//

import Foundation

// struct to hold stored prperties needed for park control system
struct ParkSystem: ParkControlSystem {
    var freeChildGuestAgeLimit : Double  = 5.0 //childeren under 5 admit for free
}

// Park Contol System main protocol 
// The system manages access , discounts and pass generation
protocol ParkControlSystem {
    var freeChildGuestAgeLimit : Double {get }

    func validateRequiredInfo (entrantType: Entrant, info:Info) -> [Error]
    func createPass(entrantType: Entrant, addionalInfo:Info) -> Pass?
    
    
    
}
extension ParkControlSystem  {
    
    // Function to validate if personal infromation provided match business rules for certain entrant type or not
    // Function will return array of errors when data is not suffcient
    func validateRequiredInfo (entrantType: Entrant, info:Info) -> [Error] {
        
        let requiredInfo = entrantType.requiredInfo
        var errors = [Error]()
        
        if requiredInfo.contains(.BirthDate) && info.birthDate == nil { errors.append(.BirthDateMissing)}
        if requiredInfo.contains(.FirstName) && info.firstName == nil {errors.append(.FirstNameMissing)}
        if requiredInfo.contains(.LastName) && info.lastName == nil {errors.append(.LastNameMissing)}
        if requiredInfo.contains(.StreetAddress) && info.streetAddress == nil {errors.append(.StreetAddressMissing)}
        if requiredInfo.contains(.City) && info.city == nil {errors.append(.CityMissing)}
        if requiredInfo.contains(.State) && info.state == nil {errors.append(.StateMissing)}
        if requiredInfo.contains(.ZipCode) && info.zipCode == nil {errors.append(.ZipCodeMissing)}
        
        // check birthdate for guest child
        if let guestType = entrantType as? Guest {
            if (guestType == .FreeChildGuest) {
                if let birthDate = info.birthDate {
                    // check age <= 5 years else add error age above limit
                    if !checkChildAgeInLimit(birthDate) {errors.append(Error.FreeChildGuestAgeAboveLimit) }
                    
                }
            }
        }
        
        return errors
    }
    
    
    // Function to create a pass only if all information needed is provided
    func createPass(entrantType: Entrant, addionalInfo:Info) -> Pass? {
        
        let errors = validateRequiredInfo(entrantType, info: addionalInfo)
        guard errors.count == 0  else {
            return nil
        }
        
        return Pass(entrantType: entrantType, passAccess: entrantType.passAccess, addionalInfo: addionalInfo)
    }
    
    // Helper function
    // Function to check Free gurst child ages is within limit
    func checkChildAgeInLimit(birthDate: NSDate) -> Bool {
        
        //let cal = NSCalendar.currentCalendar()
        let age = NSDate().timeIntervalSinceDate(birthDate)
        let ageInYears = age/(365*24*60*60)
        print ("Age: \(ageInYears) ")
        if ageInYears <= freeChildGuestAgeLimit { return true } else { return false }
        
    }
    
        
}
