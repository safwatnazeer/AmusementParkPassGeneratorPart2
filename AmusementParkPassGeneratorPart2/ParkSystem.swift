//
//  ParkSystem.swift
//  AmuesmentParkPassGenerator
//
//  Created by Safwat Shenouda on 24/09/16.
//  Copyright © 2016 Safwat Shenouda. All rights reserved.
//

import Foundation

struct ErrorComponents {
    let field : RequiredInfo
    let error : Error
}



// struct to hold stored prperties needed for park control system
struct ParkSystem: ParkControlSystem {
    var freeChildGuestAgeLimit : Double  = 5.0 //childeren under 5 admit for free
}

// Park Contol System main protocol 
// The system manages access , discounts and pass generation
protocol ParkControlSystem {
    var freeChildGuestAgeLimit : Double {get }
    func validateRequiredInfo (entrantType: Entrant, info:Info) -> [ErrorComponents]
    func createPass(entrantType: Entrant, addionalInfo:Info) -> Pass?
    
    
    
}
extension ParkControlSystem  {
    
    // Function to validate if personal infromation provided match business rules for certain entrant type or not
    // Function will return array of errors when data is not suffcient
    func validateRequiredInfo (entrantType: Entrant, info:Info) -> [ErrorComponents] {
        
        let requiredInfo = entrantType.requiredInfo
        var errors = [ErrorComponents]()
        
        if requiredInfo.contains(.BirthDate) && (info.birthDate == nil || info.birthDate == ""){
            errors.append(ErrorComponents(field:RequiredInfo.BirthDate,error: .BirthDateMissing))
        }
        if requiredInfo.contains(.FirstName) && (info.firstName == nil || info.firstName == "") {errors.append(ErrorComponents(field:RequiredInfo.FirstName,error: Error.FirstNameMissing))}
        
        if requiredInfo.contains(.LastName) && (info.lastName == nil || info.lastName == ""){errors.append(ErrorComponents(field:RequiredInfo.LastName,error: Error.LastNameMissing))}
        if requiredInfo.contains(.StreetAddress) && (info.streetAddress == nil || info.streetAddress == "") {errors.append(ErrorComponents(field:RequiredInfo.StreetAddress ,error: Error.StreetAddressMissing))}
        if requiredInfo.contains(.City) && (info.city == nil  || info.city == ""){errors.append(ErrorComponents(field:RequiredInfo.City,error: Error.CityMissing ))}
        if requiredInfo.contains(.State) && (info.state == nil || info.state == "") {errors.append(ErrorComponents(field:RequiredInfo.State,error: Error.StateMissing))}
        if requiredInfo.contains(.ZipCode) && (info.zipCode == nil  || info.zipCode == "") {errors.append(ErrorComponents(field:RequiredInfo.ZipCode,error: Error.ZipCodeMissing))}
        
        if requiredInfo.contains(RequiredInfo.ProjectNumber) && (info.projectNumber == nil  || info.projectNumber == "") {errors.append(ErrorComponents(field:.ProjectNumber,error: Error.ProjectNumberMissing))}
        if requiredInfo.contains(RequiredInfo.VendorCompany) && (info.vendorCompany == nil  || info.vendorCompany == "") {errors.append(ErrorComponents(field:RequiredInfo.VendorCompany,error: Error.VendorCompanyMissing))}
        
        // check birthdate for guest child
        if let guestType = entrantType as? Guest {
            if (guestType == .FreeChildGuest) {
                if let birthDate = info.birthDate {
                    // check age <= 5 years else add error age above limit
                    
                    if !checkChildAgeInLimit(birthDate) && birthDate != "" {errors.append(ErrorComponents(field:RequiredInfo.BirthDate,error: Error.FreeChildGuestAgeAboveLimit)) }
                    
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
    func checkChildAgeInLimit(birthDateString: String) -> Bool {
        
        //let cal = NSCalendar.currentCalendar()
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        
        if let birthDate = dateFormater.dateFromString(birthDateString)
        {
            let age = NSDate().timeIntervalSinceDate(birthDate)
            let ageInYears = age/(365*24*60*60)
            print ("Age: \(ageInYears) ")
            if ageInYears <= freeChildGuestAgeLimit { return true } else { return false }
        }
        else {
            return false
        }
    }
    
        
}
