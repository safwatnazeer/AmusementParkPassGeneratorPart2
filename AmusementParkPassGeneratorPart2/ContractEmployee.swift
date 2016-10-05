//
//  ContractEmployee.swift
//  AmusementParkPassGeneratorPart2
//
//  Created by Safwat Shenouda on 05/10/16.
//  Copyright © 2016 Safwat Shenouda. All rights reserved.
//

import Foundation

enum ContractEmployee: Entrant {
    
    case ContractEmployee(String)
    var passAccess: PassAccess {
        switch self {
        case .ContractEmployee("1001"):
            return PassAccess(rideAccessType: [], areaAccessType: [.AmuesmentAreas,.RideControlAreas], discountFood: .Discount0Food, discountMerchandise: .Discount0Merchandise)
        case .ContractEmployee("1002"):
            return PassAccess(rideAccessType: [], areaAccessType: [.AmuesmentAreas,.RideControlAreas,.MaintenanceAreas], discountFood: .Discount0Food, discountMerchandise: .Discount0Merchandise)
        case .ContractEmployee("1003"):
            return PassAccess(rideAccessType: [], areaAccessType: [.AmuesmentAreas,.RideControlAreas,.MaintenanceAreas,.KitchenAreas,.OfficeAreas], discountFood: .Discount0Food, discountMerchandise: .Discount0Merchandise)
        case .ContractEmployee("2001"):
            return PassAccess(rideAccessType: [], areaAccessType: [.OfficeAreas], discountFood: .Discount0Food, discountMerchandise: .Discount0Merchandise)
        case .ContractEmployee("2002"):
            return PassAccess(rideAccessType: [], areaAccessType: [.KitchenAreas,.MaintenanceAreas], discountFood: .Discount0Food, discountMerchandise: .Discount0Merchandise)
        default:
            return PassAccess(rideAccessType: [], areaAccessType: [], discountFood: .Discount0Food, discountMerchandise: .Discount0Merchandise)
        }
    }
    
    var requiredInfo: [RequiredInfo] {
        switch self{
        case .ContractEmployee("1001"),.ContractEmployee("1002"),.ContractEmployee("1003"),.ContractEmployee("2001"),.ContractEmployee("2002"):
            return [.FirstName, .LastName, .StreetAddress, .City , .State, .ZipCode, .ProjectNumber]
        default:
            return [.FirstName, .LastName, .StreetAddress, .City , .State, .ZipCode,.ProjectNumber]
        }
    }
    
}

