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

// To stick to DRY concept I decided to control input fields through an array of input fields, this makes validation and control much easier
// This struct defines the mapping between UI elements (UITextField ,UILabel and the corresponding data element in the Model)
struct FieldMap {
    let inputField: UITextField
    let reqInfo: RequiredInfo
    let label: UILabel
}

// To stick to DRY concept I decided to control the entrants types buttons through two array(mian buttons and sub buttons)
// This struct defines the mapping between button Label the corresponding enterant type
struct ButtonEntrantMap {
    let buttonLabel: String
    let entrantType: Entrant
}


class ViewController: UIViewController {

    // Park System
    let parkSystem = ParkSystem()
    var currentEntrantType: Entrant = Guest.ClassicGuest
    var currentSubButtonLabel = ""
    
    // Stack views
    // Buttons will be created dynamically and attached to the stack views
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
    
    // Mapping data to UI elemnets
    var inputFieldsMappingArray = [FieldMap]() //array for mapping fields to data elements
    var buttonEntrantTypesMappingArray = [ButtonEntrantMap]() // array to map buttons to enterant types
    
    // Buttons
    var currentSubButtons = [UIButton]() // Main buttons array (Guest, Employee, ..)
    var mainButtons = [UIButton]() // sub buttons (for sub types Child, Food services employee, .. )
    
    let mainButtonsList = ["Guest","Employee","Manager","Vendor"] // Main buttons labels
    // sub buttons lables in a dictionary
    let subButtonsList =
    [
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
        changeButtonsColor( mainButtonsList[0], buttonsList: mainButtons) // Make first button highlighted
        
        // Sub
        setupSubButtons( mainButtonsList[0])
        if let firsMainButtonList = subButtonsList[ mainButtonsList[0]] {
        let firstLabel = firsMainButtonList[0]
            changeButtonsColor(firstLabel , buttonsList: currentSubButtons) // Highlight first button
            
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
        
        // enable fields for first button choice
        currentEntrantType = buttonEntrantTypesMappingArray[0].entrantType
        currentSubButtonLabel = buttonEntrantTypesMappingArray[0].buttonLabel
        enableRequiredFields()
        // clear data and restore fields color
        makeAllFieldsNormal(true)
        
        // load sounds
        loadSounds()
    }
   
    // This method will enable only the required fields based on current entrant type
    // First it gets the list of required fields, then iterate through them and enable them on screen
    func enableRequiredFields() {
        
        let reqFieldsList = currentEntrantType.requiredInfo
        
        for f in inputFieldsMappingArray {
            if reqFieldsList.contains(f.reqInfo) {
                // enable field
                f.inputField.enabled = true
                f.label.textColor = UIColor.blackColor()
                f.inputField.backgroundColor = UIColor.whiteColor()
                f.inputField.textColor = UIColor.blackColor()
            }else {
                // disable field
                f.inputField.enabled = false
                f.label.textColor = UIColor.lightGrayColor()
                f.inputField.backgroundColor = UIColor.clearColor()
                f.inputField.textColor = UIColor.lightGrayColor()
                
            }
        }
        
    }
    
    // Helper method to make fields gets the normal appearence
    // This method is usually called before validation of data input. After validation fields with wrong data are highleted in red borders
    func makeAllFieldsNormal(clearData: Bool) {
        // make color normal
        for f in inputFieldsMappingArray {
            f.inputField.layer.borderWidth = 1
            f.inputField.layer.cornerRadius = 5.0
            f.inputField.layer.borderColor = UIColor.lightGrayColor().CGColor
            // clear input text
            if clearData {
                switch f.reqInfo {
                    case .BirthDate: f.inputField.text = "MM/DD/YYYY"
                    case .SSN: f.inputField.text = "###-##-####"
                    case .ProjectNumber: f.inputField.text = "######"
                    
                    default: f.inputField.text = ""
                }
                
            }
        
        }
        

    }
    
    @IBAction func createPass() {
        
    }
    
    // This method is called before segue when user clicks Generate Pass
    // It first validates the data, if all OK it will segue, otherwise it will highlight wrong fields in red borders
    // It will also display error message
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        // create Info struct
        let info = Info(birthDate: birthDateInput.text, firstName: firstNameInput.text, lastName: lastNameInput.text, streetAddress: addressInput.text, city: cityInput.text, state: stateInput.text, zipCode: zipCodeInput.text, projectNumber: projectInput.text, vendorCompany: companyInput.text,visitDate: NSDate())
        
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
            return false
        }
        else {
            return true
            
            
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPassSegue" {
        
            // Decide what is the current entrant type
            for m in buttonEntrantTypesMappingArray {
                if m.buttonLabel == currentSubButtonLabel {
                    if m.buttonLabel == "Vendor" {
                        let vendor = Vendor.Vendor(companyInput.text!)
                        currentEntrantType = vendor
                    } else  if m.buttonLabel == "Contractor" {
                        let contractor = ContractEmployee.ContractEmployee(projectInput.text!)
                        currentEntrantType = contractor
                    } else  {
                        currentEntrantType = m.entrantType
                    }
                    currentSubButtonLabel = m.buttonLabel
                }
            }
         // create Info struct
        let info = Info(birthDate: birthDateInput.text, firstName: firstNameInput.text, lastName: lastNameInput.text, streetAddress: addressInput.text, city: cityInput.text, state: stateInput.text, zipCode: zipCodeInput.text, projectNumber: projectInput.text, vendorCompany: companyInput.text,visitDate: NSDate())
            
        // Generate a pass and give it to the Pass view controller
            if let pass = parkSystem.createPass(currentEntrantType, addionalInfo: info) {
        
            if let controller = segue.destinationViewController as? PassViewController {
                controller.pass = pass // give pass info
                controller.passType = currentSubButtonLabel  // guest type to display
                controller.completionHandler = {
                    self.makeAllFieldsNormal(true)
                }
            }
            }
            else {
                print("Pass was not created ....")
            }
            
        }
    
    }

    // Helper method to show error message
    func showErrorMessage(errors:[ErrorComponents]){
        var message: String = ""
        for e in errors {
            message = message + "\(e.error.rawValue)\n"
        }
        let alert = UIAlertController(title: "Data Issues!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    // Method that responds to all main buttons
    // Based on which main button was clicked it will create the list of the sub buttons and add them to the stack view
    // It also sets the current enterant type
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
                    
                        if b.buttonLabel == "Vendor" {
                            let vendor = Vendor.Vendor(companyInput.text!)
                            currentEntrantType = vendor
                        } else  if b.buttonLabel == "Contractor" {
                            let contractor = ContractEmployee.ContractEmployee(projectInput.text!)
                            currentEntrantType = contractor
                        } else  {
                            currentEntrantType = b.entrantType
                        }

                        currentSubButtonLabel = b.buttonLabel
                        enableRequiredFields()
                        // clear data and restore fields color
                        makeAllFieldsNormal(true)
                    }
                }
            }

        }
        
    }
    
    // Method that responds to all sub buttons
    // Based on which Sub button was clicked it will enable the required fields
    // It also sets the current enterant type

    @IBAction func subButtonResponder(sender: AnyObject) {
    
        if let sender = sender as? UIButton, label = sender.titleLabel?.text {
            
            print("sender label: \(label)")
            changeButtonsColor(label, buttonsList: currentSubButtons)
            
            for m in buttonEntrantTypesMappingArray {
                if m.buttonLabel == label {
                    if m.buttonLabel == "Vendor" {
                        let vendor = Vendor.Vendor(companyInput.text!)
                        currentEntrantType = vendor
                    } else  if m.buttonLabel == "Contractor" {
                        let contractor = ContractEmployee.ContractEmployee(projectInput.text!)
                        currentEntrantType = contractor
                    } else  {
                        currentEntrantType = m.entrantType
                    }
                    currentSubButtonLabel = m.buttonLabel
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
    
    // Method to create sub buttons and add them to the stack view
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
 
    // Method to create main buttons based on the array of mainButtonsList that was defined earlier
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
    
    // Helper method to change the buttons font color so it highlights teh current selected button
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
    
    
    // Method to populate default data in only required fields based on entrant tyep
    @IBAction func populateData() {
        // populate data for only enabled fields
        for f in inputFieldsMappingArray {
            
            if f.inputField.enabled == true {
                switch f.reqInfo {
                    case .BirthDate: f.inputField.text = "10/08/2013"
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
    
    
    func loadSounds() {
        var pathToSoundFile = NSBundle.mainBundle().pathForResource("AccessGranted", ofType: "wav")
        var soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, &dingSound)
        
        pathToSoundFile = NSBundle.mainBundle().pathForResource("AccessDenied", ofType: "wav")
        soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, &buzzSound)
        
        
        
    }
    
    func playSound(sound:SystemSoundID) {
        AudioServicesPlaySystemSound(sound)
        
    }

    
   }