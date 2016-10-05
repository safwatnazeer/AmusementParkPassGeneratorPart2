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

struct FieldMap {
    let inputField: UITextField
    let reqInfo: RequiredInfo
    let label: UILabel
}
struct ButtonEntrantMap {
    let buttonLabel: String
    let entrantType: Entrant
}


class ViewController: UIViewController {

    // Park System
    let parkSystem = ParkSystem()
    var currentEntrantType: Entrant = Guest.ClassicGuest
    
    // Stack views
    @IBOutlet weak var entrantTypeSV: UIStackView!
    @IBOutlet weak var subTypeSV: UIStackView!

    
    // Input fields
    @IBOutlet weak var firstNameInput: UITextField!
    @IBOutlet weak var lastNameInput: UITextField!
    @IBOutlet weak var addressInput: UITextField!
    @IBOutlet weak var birthDateInput: UITextField!
    @IBOutlet weak var ssnInput: UITextField!
    @IBOutlet weak var projectInput: UITextField!
    @IBOutlet weak var companyInput: UITextField!
    @IBOutlet weak var cityInput: UITextField!
    @IBOutlet weak var stateInput: UITextField!
    @IBOutlet weak var zipCodeInput: UITextField!
    
    // Input fields screen labels
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var ssnLabel: UILabel!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    
    // Mapping data to UI
    var inputFieldsMappingArray = [FieldMap]()
    var buttonEntrantTypesMappingArray = [ButtonEntrantMap]()
    
    // Buttons
    var currentSubButtons = [UIButton]()
    var mainButtons = [UIButton]()
    
    let mainButtonsList = ["Guest","Employee","Manager","Vendor"]
    let subButtonsList = [
        "Guest":["Child", "Adult", "Senior","VIP","Season Pass"] ,
        "Employee": ["Food Services","Ride Services","Maintenance", "Contractor"],
        "Manager": ["Manager"],
        "Vendor": ["Vendor"]
    ]
    
   
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // setup buttons
        // Main
        setupMainButtons()
        changeButtonsColor( mainButtonsList[0], buttonsList: mainButtons)
        
        // Sub
        setupSubButtons( mainButtonsList[0])
        if let firsMainButtonList = subButtonsList[ mainButtonsList[0]] {
        let firstLabel = firsMainButtonList[0]
            changeButtonsColor(firstLabel , buttonsList: currentSubButtons)
            
        }
        
        // setup array of input fields and thier labels mapping to required fields enum
        inputFieldsMappingArray = [
            FieldMap(inputField: firstNameInput, reqInfo: RequiredInfo.FirstName, label: firstNameLabel),
            FieldMap(inputField: lastNameInput , reqInfo: RequiredInfo.LastName, label: lastNameLabel),
            FieldMap(inputField: addressInput, reqInfo: RequiredInfo.StreetAddress, label: streetLabel),
            FieldMap(inputField: birthDateInput, reqInfo: RequiredInfo.BirthDate, label: birthDateLabel),
            FieldMap(inputField: projectInput, reqInfo: RequiredInfo.ProjectNumber, label: projectLabel),
            FieldMap(inputField: ssnInput, reqInfo: RequiredInfo.SSN, label: ssnLabel),
            FieldMap(inputField: cityInput, reqInfo: RequiredInfo.City, label: cityLabel),
            FieldMap(inputField: stateInput, reqInfo: RequiredInfo.State, label: stateLabel),
            FieldMap(inputField: zipCodeInput, reqInfo: RequiredInfo.ZipCode, label: zipCodeLabel),
            FieldMap(inputField: companyInput, reqInfo: RequiredInfo.VendorCompany, label: companyLabel),
        
        ]
        
        

        
        // map sub buttons labels to equivalent enterant types
        buttonEntrantTypesMappingArray = [
            ButtonEntrantMap(buttonLabel: "Child", entrantType: Guest.FreeChildGuest),
            ButtonEntrantMap(buttonLabel: "Adult", entrantType: Guest.ClassicGuest),
            ButtonEntrantMap(buttonLabel: "Senior", entrantType: Guest.SeniorGuest),
            ButtonEntrantMap(buttonLabel: "VIP", entrantType: Guest.VIPGuest),
            ButtonEntrantMap(buttonLabel: "Season Pass", entrantType: Guest.SeasonPassGuest),
            ButtonEntrantMap(buttonLabel: "Food Services", entrantType: Employee.HourlyEmployeeFoodServices),
            ButtonEntrantMap(buttonLabel: "Ride Services", entrantType: Employee.HourlyEmployeeRideServices),
            ButtonEntrantMap(buttonLabel: "Maintenance", entrantType: Employee.HourlyEmployeeMaintenance),
            ButtonEntrantMap(buttonLabel: "Manager", entrantType: Employee.Manager),
            ButtonEntrantMap(buttonLabel: "Contractor", entrantType: ContractEmployee.ContractEmployee("")),
            ButtonEntrantMap(buttonLabel: "Vendor", entrantType: Vendor.Vendor(""))
        ]
        
        // enable fields for first choice
        currentEntrantType = buttonEntrantTypesMappingArray[0].entrantType
        enableRequiredFields()
        // clear data and restore fields color
        makeAllFieldsNormal(true)
        
        
    }
   
    func enableRequiredFields() {
        
        let reqFieldsList = currentEntrantType.requiredInfo
        
        for f in inputFieldsMappingArray {
            if reqFieldsList.contains(f.reqInfo) {
                // enable field
                f.inputField.enabled = true
                f.label.textColor = UIColor.blackColor()
                f.inputField.backgroundColor = UIColor.whiteColor()
            }else {
                // disable field
                f.inputField.enabled = false
                f.label.textColor = UIColor.lightGrayColor()
                f.inputField.backgroundColor = UIColor.clearColor()
                
            }
        }
        
    }
    
    func makeAllFieldsNormal(clearData: Bool) {
        
        // make color normal
        for f in inputFieldsMappingArray {
            f.inputField.layer.borderWidth = 1
            f.inputField.layer.cornerRadius = 5.0
            f.inputField.layer.borderColor = UIColor.lightGrayColor().CGColor
            // clear input text
            if clearData { f.inputField.text = "" }
        
        }
        

    }
    
    @IBAction func createPass() {
        
        // create Info struct
        let info = Info(birthDate: nil, firstName: firstNameInput.text, lastName: lastNameInput.text, streetAddress: addressInput.text, city: cityInput.text, state: stateInput.text, zipCode: zipCodeInput.text, projectNumber: projectInput.text, vendorCompany: companyInput.text,visitDate: NSDate())
        
      let errors = parkSystem.validateRequiredInfo(currentEntrantType, info: info)
        for e in errors { print("There is error: \(e)")}
        
        // make all fields normal
        makeAllFieldsNormal(false)
        
        // mark only faulty fields
        for f in inputFieldsMappingArray {
            for e in errors {
                if  e.field == f.reqInfo {
                    f.inputField.layer.borderWidth = 3
                    f.inputField.layer.cornerRadius = 5.0
                    f.inputField.layer.borderColor = UIColor.redColor().CGColor
                }
            }
        }
        // show error message
        if errors.count > 0 {
            showErrorMessage(errors)
        }
        else {
            // create pass
        }
    }

    func showErrorMessage(errors:[ErrorComponents]){
        var message: String = ""
        for e in errors {
            message = message + "\(e.error.rawValue)\n"
        }
        let alert = UIAlertController(title: "Data Issues!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func mainButtonResponder(sender: AnyObject) {
    
        if let sender = sender as? UIButton,label = sender.titleLabel?.text {
            changeButtonsColor(label, buttonsList: mainButtons)
            setupSubButtons(label)
            if let subButtonsList = subButtonsList[label] {
                let firstLabel = subButtonsList[0]
               // currentEntrantType = Guest.ClassicGuest
                changeButtonsColor(firstLabel , buttonsList: currentSubButtons)
                for b in buttonEntrantTypesMappingArray{
                    if b.buttonLabel == firstLabel {
                        currentEntrantType = b.entrantType
                        enableRequiredFields()
                        // clear data and restore fields color
                        makeAllFieldsNormal(true)
                    }
                }
            }

        }
        
    }
    
    @IBAction func subButtonResponder(sender: AnyObject) {
    
    
        if let sender = sender as? UIButton, label = sender.titleLabel?.text {
            
            print("sender label: \(label)")
            changeButtonsColor(label, buttonsList: currentSubButtons)
            
            for m in buttonEntrantTypesMappingArray {
                if m.buttonLabel == label {
                    currentEntrantType = m.entrantType
                    enableRequiredFields()
                    // clear data and restore fields color
                    makeAllFieldsNormal(true)
                }
            }
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
                b.setTitleColor(UIColor(red: 181.0/255.0, green: 188.0/255.0, blue: 193.0/255.0, alpha: 1.0),forState: .Normal)
            }
        }
    }
    
    @IBAction func populateData() {
        
        // populate data for only enabled fields
        for f in inputFieldsMappingArray {
            
            if f.inputField.enabled == true {
                switch f.reqInfo {
                    case .BirthDate: f.inputField.text = "10/19/1995"
                    case .FirstName: f.inputField.text = "Safwat"
                    case .LastName: f.inputField.text = "Shenouda"
                    case .VendorCompany: f.inputField.text = "Acme"
                    case .StreetAddress: f.inputField.text = "10 Blue Mountain st."
                    case .City: f.inputField.text = "Amsterdam"
                    case .State: f.inputField.text = "NY"
                    case .ZipCode: f.inputField.text = "153567"
                    case .ProjectNumber: f.inputField.text = "1001"
                    case .SSN: f.inputField.text = "###-##-####"
                default:
                    f.inputField.text = ""
                }
            }
        }
        
        
        
    }
    
   }