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
    @IBOutlet weak var subTypeSV: UIStackView!
    @IBOutlet weak var textF: UITextField!
    
    var currentSubButtons = [UIButton]()
    var mainButtons = [UIButton]()
    
    let mainButtonsList = ["Guest","Employee","Manager","Vendor"]
    let subButtonsList = [
        "Guest":["Child", "Adult", "Senior","VIP","Season Pass"] ,
        "Employee": ["Food Services","Ride Services","Maintenance", "Contractor"],
        "Manager": ["Manager"],
        "Vendor": ["Vendor"]
    ]
  //  @IBOutlet weak var childButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       setupMainButtons()
    
        
       changeButtonsColor( mainButtonsList[0], buttonsList: mainButtons)
       
        setupSubButtons( mainButtonsList[0])
        if let firsMainButtonList = subButtonsList[ mainButtonsList[0]] {
        let firstLabel = firsMainButtonList[0]
            changeButtonsColor(firstLabel , buttonsList: currentSubButtons)
        }
        
        textF.tag = RequiredInfo.FirstName.rawValue
        
    }

    @IBAction func mainButtonResponder(sender: AnyObject) {
    
        if let sender = sender as? UIButton,label = sender.titleLabel?.text {
            changeButtonsColor(label, buttonsList: mainButtons)
            
            
            setupSubButtons(label)
            if let subButtonsList = subButtonsList[label] {
                let firstLabel = subButtonsList[0]
                changeButtonsColor(firstLabel , buttonsList: currentSubButtons)
            }

        }
        
    }
    
    @IBAction func subButtonResponder(sender: AnyObject) {
    
    
        if let sender = sender as? UIButton, label = sender.titleLabel?.text {
            
            print("sender label: \(label)")
            changeButtonsColor(label, buttonsList: currentSubButtons)
        }
        
        
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setupSubButtons(subButtonsListKey: String) {
        
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
                subTypeSV.addArrangedSubview(newButton)
            }
        
        }
        else
        {
            print ("Error in button list key")
        }
    
}
    func setupMainButtons() {
        
        // create main buttons
       
            for t in mainButtonsList
            {
                let newButton = UIButton(type: .System)
                newButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                newButton.backgroundColor = UIColor(red: 155.0/255.0, green: 77.0/255.0, blue: 196.0/255.0, alpha: 1.0)
                newButton.setTitle(t, forState: .Normal)
                newButton.titleLabel?.font = UIFont(name: "System", size: 18)
                newButton.addTarget(self, action: #selector(mainButtonResponder), forControlEvents: .TouchUpInside)
                mainButtons.append(newButton)
                entrantTypeSV.addArrangedSubview(newButton)
            }
        
    }
    
    func changeButtonsColor(buttonLabelToHighlight:String, buttonsList: [UIButton]) {
        
        for b in buttonsList {
            let label = b.titleLabel?.text
            if label == buttonLabelToHighlight {
                b.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            } else  {
                b.setTitleColor(UIColor(red: 181.0/255.0, green: 188.0/255.0, blue: 193.0/255.0, alpha: 1.0)
, forState: .Normal)
            }
        }
    }
    
    
   }