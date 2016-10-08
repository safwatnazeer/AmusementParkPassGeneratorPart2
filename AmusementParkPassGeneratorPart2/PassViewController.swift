//
//  passViewController.swift
//  AmusementParkPassGeneratorPart2
//
//  Created by Safwat Shenouda on 06/10/16.
//  Copyright © 2016 Safwat Shenouda. All rights reserved.
//

import UIKit

typealias HANDLER = ()->()

class PassViewController: UIViewController {

    var pass : Pass?
    var passType: String?
    var completionHandler : HANDLER?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var passTypeLabel: UILabel!
    @IBOutlet weak var accessListLabel: UILabel!
    @IBOutlet weak var testingResults: UILabel!
    
    
    
    @IBAction func createNewPass(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        // call main view controller to clear all fields
        if let completionHandler = completionHandler {
            completionHandler()
        }else {
            fatalError()
        }
        
    }
    
    override func viewDidLoad() {
        print(pass?.addionalInfo)
        
        if let pass = pass {
        nameLabel?.text = "\(pass.addionalInfo.firstName!) \(pass.addionalInfo.lastName!)"
        passTypeLabel?.text = "\(passType!) Pass"
        
        var accessList: String = ""
        
        for rideAccess in (pass.passAccess.rideAccessType) {
            accessList += "- \(rideAccess.rawValue)\n"
        }
        for areaAccess in (pass.passAccess.areaAccessType) {
            accessList += "- \(areaAccess.rawValue)\n"
        }
        
        if pass.passAccess.discountFood != DiscountAccessFood.Discount0Food {
            accessList += "- \(pass.passAccess.discountFood.rawValue)% Food Discount\n"
        }
        if pass.passAccess.discountMerchandise != DiscountAccessMerchandise.Discount0Merchandise {
            accessList += "- \(pass.passAccess.discountMerchandise.rawValue)% Merch Discount"
        }
        
        accessListLabel.text = accessList
        }
    
    }
    
    @IBAction func test(sender: AnyObject) {

        if let button = sender as? UIButton, buttonLabel = button.titleLabel, buttonLabelText = buttonLabel.text {
            print(buttonLabelText)
     
            var swiperToTest: Swiper?
            
            switch buttonLabelText {
            case "Main Admin Office":
                swiperToTest = RideAccessPoint(accessToCheck: AreaAccessType.OfficeAreas, locationName: "Main Admin Office")
            case "Skip Line Dumbo Gate":
                swiperToTest = RideAccessPoint(accessToCheck: RideAccessType.SkipAllRidesLines, locationName: "Skip Line Dumbo Gate")
            case "Thunder Mountain Ride":
                swiperToTest = RideAccessPoint(accessToCheck: RideAccessType.AllRides, locationName: "Thunder Mountain Ride")
                
            case "Main Control Room":
                swiperToTest = AreaAccessPoint(accessToCheck: AreaAccessType.RideControlAreas, locationName: "Main Control Room")
            case "Staff Kitchen Door":
                swiperToTest = AreaAccessPoint(accessToCheck: AreaAccessType.KitchenAreas, locationName: "Staff Kitchen Door")
            case "Cash Register KFC":
                swiperToTest = FoodDiscountSwiper(locationName: "Cash Register KFC")
            case "Cash Register Pirates Store":
                swiperToTest = MerchandiseDiscountSwiper(locationName: "Cash Register Pirates Store")
            case "Maintenance Areas":
                swiperToTest = AreaAccessPoint(accessToCheck: AreaAccessType.MaintenanceAreas, locationName: "Maintenance Areas")
            case "Amusement Areas":
                swiperToTest = AreaAccessPoint(accessToCheck: AreaAccessType.AmuesmentAreas, locationName: "Amusement Areas")
                
            default:
                swiperToTest = nil
            }
            
            if let swiperToTest = swiperToTest {
            let swipeTestResults = swiperToTest.swipe(pass!)
            if swipeTestResults.0 == true // access granted
            {
                testingResults.backgroundColor = UIColor(red: 12/255.0, green: 100/255.0, blue: 0, alpha: 1.0)
            }else {
                testingResults.backgroundColor = UIColor.redColor()
            }
            testingResults.textColor = UIColor.whiteColor()
            testingResults.text = swipeTestResults.1

            }
            
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

