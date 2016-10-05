//
//  BasicElements.swift
//  AmuesmentParkPassGenerator
//
//  Created by Safwat Shenouda on 23/09/16.
//  Copyright © 2016 Safwat Shenouda. All rights reserved.
//

import Foundation

// common protocol for all types of access or discounts
protocol AccessPrevilige {
    
}

// enum for all areas to be accessed
enum AreaAccessType: AccessPrevilige {
    
    case AmuesmentAreas
    case KitchenAreas
    case RideControlAreas
    case MaintenanceAreas
    case OfficeAreas
    
}

// enum for rides access gates types
enum RideAccessType: AccessPrevilige {
    case AllRides
    case SkipAllRidesLines
}

// enum for possible food dicounts
enum DiscountAccessFood : Int,AccessPrevilige {
    case Discount0Food = 0
    case Discount10Food = 10
    case Discount15Food = 15
    case Discount25Food = 25
}

// enum for possible merchandise discounts
enum DiscountAccessMerchandise : Int,AccessPrevilige {
    case Discount0Merchandise = 0
    case Discount10Merchandise = 10
    case Discount20Merchandise = 20
    case Discount25Merchandise = 25
}


// All Error types for missing info or other possibl errors
enum Error: String {
    case NoError = "No Error"
    case FreeChildGuestAgeAboveLimit = "Free child guest age is above limit "
    case FreeChildAgeMissing = "Child age is missing"
    case PersonalDataNotProvided = "Personal data is not provided"
    case BirthDateMissing = "Birth date is missing"
    case FirstNameMissing = "First name is missing"
    case LastNameMissing = "Last name is missing"
    case StreetAddressMissing = "Street Address is missing"
    case CityMissing = "City is missing"
    case StateMissing = "State is missing"
    case ZipCodeMissing = "Zip code is missing"
}


// struct to define what access previliges a pass holds
struct PassAccess {
    var rideAccessType: [RideAccessType]
    var areaAccessType: [AreaAccessType]
    var discountFood: DiscountAccessFood
    var discountMerchandise: DiscountAccessMerchandise
}

// enum to list types of required personal information
enum RequiredInfo
{
    case BirthDate
    case FirstName
    case LastName
    case StreetAddress
    case City
    case State
    case ZipCode
    
    case ProjectNumber
    case VendorCompany
    case VisitDate
    case SSN
}

// struct to hold actual personal information of an entrant
struct Info {
    var birthDate: NSDate?
    var firstName: String?
    var lastName: String?
    var streetAddress: String?
    var city: String?
    var state: String?
    var zipCode: String?
    
    var projectNumber: String?
    var vendorCompany: String?
    var visitDate:NSDate?
}


// struct to represent a entrant pass with all information and access perviliges
struct Pass {
    var entrantType: Entrant
    var passAccess: PassAccess
    var addionalInfo: Info
    
}
