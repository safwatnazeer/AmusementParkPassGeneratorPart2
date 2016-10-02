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
    case Discount20Merchandise = 20
    case Discount25Merchandise = 25
}


// All Error types for missing info or other possibl errors
enum Error {
    case NoError
    case FreeChildGuestAgeAboveLimit
    case FreeChildAgeMissing
    case PersonalDataNotProvided
    case BirthDateMissing
    case FirstNameMissing
    case LastNameMissing
    case StreetAddressMissing
    case CityMissing
    case StateMissing
    case ZipCodeMissing
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
}


// struct to represent a entrant pass with all information and access perviliges
struct Pass {
    var entrantType: Entrant
    var passAccess: PassAccess
    var addionalInfo: Info
    
}
