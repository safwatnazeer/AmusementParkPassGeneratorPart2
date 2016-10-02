//
//  Swiper.swift
//  AmuesmentParkPassGenerator
//
//  Created by Safwat Shenouda on 24/09/16.
//  Copyright © 2016 Safwat Shenouda. All rights reserved.
//

import Foundation
import AVFoundation

// General swiper protocol for all swiper types (on gates or merchandise/food purchase points)
protocol Swiper {
    var locationName : String {get}     // location where swiper is installed
    func greetForBirthday(pass: Pass) -> String //
    func swipe(pass: Pass) -> (Bool,String)
}


extension Swiper {
    
    // extention to give any swiper extra feature to personalise birthday message
    // If birthdate is avialble it will check if it is like today and return a personalized message, otherwise it return empty string
    func greetForBirthday(pass: Pass) -> String {
        if let entrantBirthDate = pass.addionalInfo.birthDate {
            let cal = NSCalendar.currentCalendar()
            let entrateBirthDateComp = cal.components([.Day,.Month], fromDate: entrantBirthDate )
            let todayDateComp = cal.components([.Day,.Month], fromDate: NSDate())
            
            if entrateBirthDateComp.day == todayDateComp.day && entrateBirthDateComp.month == todayDateComp.month {
                return " and Happy Birthday 😃"
            }
        }
        return ""
        
    }
}

// prtocol for swipers installed on access gates/doors 

protocol AccessGate: Swiper {
    var accessToCheck: AccessPrevilige {get} // swiper should know what access type to check for (Gate acces/ discount )
    
}

// define access point type to contol differnt park areas access (offices/kitchen/ride control/ .. )
struct AreaAccessPoint: AccessGate {
    var accessToCheck: AccessPrevilige
    let locationName: String
    
    func swipe(pass: Pass) -> (Bool, String) {
         if let accessToCheck = self.accessToCheck as? AreaAccessType {
            
            if pass.passAccess.areaAccessType.contains(accessToCheck) {
                let bdGreeting = greetForBirthday(pass)
                 AudioServicesPlaySystemSound(dingSound)
                return (true, "Welcome\(bdGreeting)")
            }
        }
         AudioServicesPlaySystemSound(buzzSound)
        return (false,"Sorry, You cant admit here")
    }
}

// define access point type to contol differnt rides access
struct RideAccessPoint: AccessGate {
    
    var accessToCheck: AccessPrevilige
    let locationName: String
    
    func swipe(pass: Pass) -> (Bool, String) {
        
        if let accessToCheck = self.accessToCheck as? RideAccessType {
            
            if pass.passAccess.rideAccessType.contains(accessToCheck) {
                let bdGreeting = greetForBirthday(pass)
                 AudioServicesPlaySystemSound(dingSound)
                return (true, "Welcome\(bdGreeting)")
            }
        }
         AudioServicesPlaySystemSound(buzzSound)
        return (false,"Sorry, You cant admit here")
    }
}

// define swiper type to allow food discount at food purchase points
struct FoodDiscountSwiper: Swiper {
    let locationName: String
    func swipe(pass: Pass) -> (Bool, String) {
        
        if pass.passAccess.discountFood != DiscountAccessFood.Discount0Food
        {
            let discountPercentage =  pass.passAccess.discountFood.rawValue
            let bdGreeting = greetForBirthday(pass)
             AudioServicesPlaySystemSound(dingSound)
            return (true, "Welcome\(bdGreeting), you have \(discountPercentage)% discount on Food.")
            
        } else {
             AudioServicesPlaySystemSound(buzzSound)
            return (false, "Sorry, you have no discount on Food.")
        }
        
    }
}
// define swiper type to allow merchandise discount at merchandise purchase points
struct MerchandiseDiscountSwiper: Swiper {
    
    let locationName: String
    func swipe(pass: Pass) -> (Bool, String) {
        
        if pass.passAccess.discountMerchandise != DiscountAccessMerchandise.Discount0Merchandise
        {
            let discountPercentage =  pass.passAccess.discountMerchandise.rawValue
            let bdGreeting = greetForBirthday(pass)
             AudioServicesPlaySystemSound(dingSound)
            return (true, "Welcome\(bdGreeting), you have \(discountPercentage)% discount on Merchandise.")
            
        } else {
            AudioServicesPlaySystemSound(buzzSound)
            return (false, "Sorry, you have no discount on Merchandise.")
            
        }
        
    }
    
}


        


    

