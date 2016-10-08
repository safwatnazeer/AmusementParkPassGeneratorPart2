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
    //
    // Input validation is included for Extra Credit (validate Length of text fields and type of data for numerical fields)
    
    func validateRequiredInfo (entrantType: Entrant, info:Info) -> [ErrorComponents] {
        
        let requiredInfo = entrantType.requiredInfo
        var errors = [ErrorComponents]()
        
        if requiredInfo.contains(.FirstName) {
        if (info.firstName == nil || info.firstName == "") {errors.append(ErrorComponents(field:.FirstName,error: Error.FirstNameMissing))} else
        if  info.firstName?.characters.count < firstNameMinLength {errors.append(ErrorComponents(field: .FirstName, error: .FirstNameTooShort))}
        }
        
        if requiredInfo.contains(.LastName) {
        if (info.lastName == nil || info.lastName == ""){errors.append(ErrorComponents(field:RequiredInfo.LastName,error: Error.LastNameMissing))} else
        if info.lastName?.characters.count < lastNameMinLength {errors.append(ErrorComponents(field: .LastName, error: .LastNameTooShort))}
        }
        if requiredInfo.contains(.StreetAddress) {
        if (info.streetAddress == nil || info.streetAddress == "") {errors.append(ErrorComponents(field:.StreetAddress ,error: .StreetAddressMissing))} else
        if info.streetAddress?.characters.count < streetAddressMinLength {errors.append(ErrorComponents(field: .StreetAddress, error: .StreetAddressTooShort))}
        }
        if requiredInfo.contains(.City) {
        if (info.city == nil  || info.city == ""){errors.append(ErrorComponents(field:RequiredInfo.City,error: Error.CityMissing ))} else
        if info.city?.characters.count < cityMinLength {errors.append(ErrorComponents(field: .City, error: .CityTooShort))}
        }
        
        if requiredInfo.contains(.State) {
        if (info.state == nil || info.state == "") {errors.append(ErrorComponents(field:RequiredInfo.State,error: Error.StateMissing))} else
        if info.state?.characters.count < stateMinLength {errors.append(ErrorComponents(field: .State, error: .StateTooShort))}
        }
        if requiredInfo.contains(RequiredInfo.VendorCompany) {
        if (info.vendorCompany == nil  || info.vendorCompany == "") {errors.append(ErrorComponents(field:.VendorCompany,error: .VendorCompanyMissing))} else
        if info.vendorCompany?.characters.count < companyMinLength {errors.append(ErrorComponents(field: .VendorCompany, error: .CompanyTooShort))}
        }
        if requiredInfo.contains(.ZipCode) {
        if (info.zipCode == nil  || info.zipCode == "") {errors.append(ErrorComponents(field:RequiredInfo.ZipCode,error: Error.ZipCodeMissing))} else
        if info.zipCode?.characters.count < zipCodeMinLength {errors.append(ErrorComponents(field: .ZipCode, error: .ZipCodeTooShort))}
        if !validateNumber(info.zipCode!) {errors.append(ErrorComponents(field: .ZipCode, error: .ZipCodeInvalid))}
        }
        
        if requiredInfo.contains(RequiredInfo.ProjectNumber) {
        if (info.projectNumber == nil  || info.projectNumber == "") {errors.append(ErrorComponents(field:.ProjectNumber,error: .ProjectNumberMissing))} else
        if info.projectNumber?.characters.count < projectMinLength {errors.append(ErrorComponents(field: .ZipCode, error: .ZipCodeTooShort))}
        if !validateNumber(info.projectNumber!) {errors.append(ErrorComponents(field: .ProjectNumber, error: .ProjectNumberInvalid))}

        }
        
        if requiredInfo.contains(.BirthDate) {
        if (info.birthDate == nil || info.birthDate == ""){errors.append(ErrorComponents(field:.BirthDate,error: .BirthDateMissing))} else
                if info.birthDate?.characters.count < birthDateMinLength {errors.append(ErrorComponents(field: .BirthDate, error: .BirthDateTooShort))} else
        // check birthdate for guest child
        if let guestType = entrantType as? Guest {
            if (guestType == .FreeChildGuest) {
                if let birthDate = info.birthDate {
                    // check age <= 5 years else add error age above limit
                    
                    if !checkChildAgeInLimit(birthDate) && birthDate != "" {errors.append(ErrorComponents(field:RequiredInfo.BirthDate,error: Error.FreeChildGuestAgeAboveLimit)) }
                    
                }
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
    // validate that field contains number only
    func validateNumber(field: String) -> Bool {
        
        if let _ = Int(field) {
            return true
        }
        else {
            return false
        }
    }
    
        
}
