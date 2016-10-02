//
//  ViewController.swift
//  AmusementParkPassGeneratorPart2
//
//  Created by Safwat Shenouda on 02/10/16.
//  Copyright © 2016 Safwat Shenouda. All rights reserved.
//

import UIKit
import AVFoundation

// Make sounds global vars
var dingSound: SystemSoundID = 0     // Access granted sound
var buzzSound: SystemSoundID = 1     // Access Denied  sound


class ViewController: UIViewController {

    @IBOutlet weak var entrantTypeSV: UIStackView!
    
    
    @IBOutlet weak var guestSubTypeSV: UIStackView!
    
    var currentSubButtons = [UIButton]()
    
    let subButtonsList = [
        "Guest":["Child", "Adult", "Senior","VIP","Season Pass"] ,
        "Employee": ["Food Services","Ride Services","Maintenance", "Contractor"],
        "Manager": ["Manager"],
        "Vendor": ["Vendor"]
    ]
  //  @IBOutlet weak var childButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
       setupButtons("Guest")
    }

    @IBAction func mainButton(sender: AnyObject) {
    
        if let sender = sender as? UIButton,label = sender.titleLabel?.text {
            setupButtons(label)
        }
        
    }
    
    @IBAction func subButtonResponder(sender: AnyObject) {
    
        print ("Button 1 .. this called me\(sender)")
    
        if let sender = sender as? UIButton, label = sender.titleLabel?.text {
            
            print("sender label: \(label)")
        }
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setupButtons(subButtonsListKey: String) {
        
        //remove old buttons
        for b in currentSubButtons {
            b.removeFromSuperview()
        }
        
        // create new buttons
        if let guestSubTypes = subButtonsList[subButtonsListKey]
        {
        for t in guestSubTypes
        {
            let newButton = UIButton(type: .System)
            newButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            newButton.backgroundColor = UIColor.blackColor()
            newButton.setTitle(t, forState: .Normal)
                
            newButton.addTarget(self, action: #selector(subButtonResponder), forControlEvents: .TouchUpInside)
            currentSubButtons.append(newButton)
            guestSubTypeSV.addArrangedSubview(newButton)
        }
        }
        else
        {
            print ("Error in button list key")
        }
    
}

}