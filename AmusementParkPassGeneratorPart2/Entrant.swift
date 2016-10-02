//
//  Model.swift
//  AmuesmentParkPassGenerator
//
//  Created by Safwat Shenouda on 22/09/16.
//  Copyright © 2016 Safwat Shenouda. All rights reserved.
//

import Foundation

// General protocol for all enrants types
protocol Entrant {
    var passAccess: PassAccess {get}
    var requiredInfo : [RequiredInfo] {get}
}

// enum to define differnt types of guests
enum Guest : Entrant {
        case ClassicGuest
        case VIPGuest
        case FreeChildGuest
    
    // Business rules for allowed access and discount types
    var passAccess: PassAccess {
        switch self {
        case .ClassicGuest:
            return PassAccess(rideAccessType: [.AllRides], areaAccessType: [.AmuesmentAreas], discountFood: .Discount0Food, discountMerchandise: .Discount0Merchandise)
        case .VIPGuest :
            return PassAccess(rideAccessType: [.SkipAllRidesLines,.AllRides], areaAccessType: [.AmuesmentAreas], discountFood: .Discount10Food, discountMerchandise: .Discount20Merchandise)
        case .FreeChildGuest:
            return PassAccess(rideAccessType: [.AllRides], areaAccessType: [.AmuesmentAreas], discountFood: .Discount0Food, discountMerchandise: .Discount0Merchandise)
        }
    }
    
    //Business rules for required information each guest type
    var requiredInfo: [RequiredInfo] {
        switch self {
        case .ClassicGuest:
            return []
        case .VIPGuest:
            return[]
        case .FreeChildGuest:
            return[RequiredInfo.BirthDate]
        }
    }

}

enum Employee: Entrant {
    case HourlyEmployeeFoodServices
    case HourlyEmployeeRideServices
    case HourlyEmployeeMaintenance
    case Manager
    
    // Business rules for allowed access and discount based on employee type
    var passAccess: PassAccess {
        switch self {
            case .HourlyEmployeeFoodServices:
                return PassAccess(rideAccessType: [.AllRides], areaAccessType: [.AmuesmentAreas,.KitchenAreas], discountFood: .Discount15Food, discountMerchandise: .Discount25Merchandise)
            case .HourlyEmployeeRideServices:
                        // project instructions gives ride service employees access to all rides as well
                        return PassAccess(rideAccessType: [.AllRides], areaAccessType: [.AmuesmentAreas,.RideControlAreas], discountFood: .Discount15Food, discountMerchandise: .Discount25Merchandise)
            case .HourlyEmployeeMaintenance:
                        return PassAccess(rideAccessType: [.AllRides], areaAccessType: [.AmuesmentAreas,.MaintenanceAreas,.RideControlAreas,.KitchenAreas], discountFood: .Discount15Food, discountMerchandise: .Discount25Merchandise)
            case .Manager:
                        return PassAccess(rideAccessType: [.AllRides], areaAccessType: [.AmuesmentAreas,.MaintenanceAreas,.RideControlAreas,.KitchenAreas,.OfficeAreas], discountFood: .Discount15Food, discountMerchandise: .Discount25Merchandise)
        }
    }
    
    //Business rules for required information each employee type
    var requiredInfo: [RequiredInfo] {
        switch self{
            case .HourlyEmployeeFoodServices,.HourlyEmployeeRideServices,.HourlyEmployeeMaintenance,.Manager:
                return [.FirstName, .LastName, .StreetAddress, .City , .State, .ZipCode]
        }

    }

}








