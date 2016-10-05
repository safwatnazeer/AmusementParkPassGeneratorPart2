//
//  Vendor.swift
//  AmusementParkPassGeneratorPart2
//
//  Created by Safwat Shenouda on 05/10/16.
//  Copyright © 2016 Safwat Shenouda. All rights reserved.
//

import Foundation

enum Vendor: Entrant {
    case Vendor(String)
    
    var passAccess: PassAccess {
        switch self {
            
        case .Vendor("Acme"):
            return PassAccess(rideAccessType: [], areaAccessType: [.KitchenAreas], discountFood: .Discount0Food, discountMerchandise: .Discount0Merchandise)
        case .Vendor("Orkin"):
            return PassAccess(rideAccessType: [], areaAccessType: [.AmuesmentAreas,.RideControlAreas,.KitchenAreas], discountFood: .Discount0Food, discountMerchandise: .Discount0Merchandise)
        case .Vendor("Fedex"):
            return PassAccess(rideAccessType: [], areaAccessType: [.MaintenanceAreas,.OfficeAreas], discountFood: .Discount0Food, discountMerchandise: .Discount0Merchandise)
        case .Vendor("NW Electrical"):
            return PassAccess(rideAccessType: [], areaAccessType: [.AmuesmentAreas,.RideControlAreas,.MaintenanceAreas,.KitchenAreas,.OfficeAreas], discountFood: .Discount0Food, discountMerchandise: .Discount0Merchandise)
        default:
            return PassAccess(rideAccessType: [], areaAccessType: [], discountFood: .Discount0Food, discountMerchandise: .Discount0Merchandise)
        }
    }
    
    var requiredInfo: [RequiredInfo] {
        switch self{
        case .Vendor("Acme"), .Vendor("Orkin"),.Vendor("Fedex"),.Vendor("NW Electrical"):
            return [.FirstName, .LastName,.VendorCompany, .VisitDate, .BirthDate  ]
        default:
            return [.FirstName, .LastName,.VendorCompany, .VisitDate, .BirthDate  ]
        }
    }
    
}
