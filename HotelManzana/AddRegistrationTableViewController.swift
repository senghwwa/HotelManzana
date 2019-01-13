//
//  AddRegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Seng Hwwa on 07/01/2019.
//  Copyright © 2019 senghwabeh. All rights reserved.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController, SelectRoomTypeTableViewControllerDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkInDatePicker: UIDatePicker!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkOutDatePicker: UIDatePicker!
    @IBOutlet weak var numberOfAdultsLabel: UILabel!
    @IBOutlet weak var numberOfAdultsStepper: UIStepper!
    @IBOutlet weak var numberOfChildrenLabel: UILabel!
    @IBOutlet weak var numberOfChildrenStepper: UIStepper!
    @IBOutlet weak var wifiSwitch: UISwitch!
    @IBOutlet weak var roomTypeLabel: UILabel!
    @IBOutlet weak var doneButtonTapped: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var numberOfNightsLabel: UILabel!
    @IBOutlet weak var chargeRoomTypeLabel: UILabel!
    @IBOutlet weak var chargeWifiLabel: UILabel!
    @IBOutlet weak var chargeTotalLabel: UILabel!
    
    
    let checkInDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
    let roomTypeSelectCellIndexPath = IndexPath(row: 0, section: 4)
    var isCheckInDatePickerShown: Bool = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInDatePickerShown
        }
    }
    var isCheckOutDatePickerShown: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerShown
        }
    }
    
    var roomType: RoomType?
    var tableMode: String?
    var registration: Registration?
    var chargeTotal: Double = 0.0
    
    // Added this override so that I can influence the cell property of user interaction enablement before the tableview is loaded. Only way to prevent user interaction at tableview initialisation
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if tableMode == "VIEW" {
            
            // disabling entire tableview also stops ability to scroll table eg. in landscape mode. So revert to disabling cell
            //tableView.isUserInteractionEnabled = false
            let cell = tableView.cellForRow(at: roomTypeSelectCellIndexPath)
            cell?.isUserInteractionEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tableMode == "VIEW" {
            firstNameTextField.isEnabled = false
            lastNameTextField.isEnabled = false
            emailTextField.isEnabled = false
            checkInDatePicker.isEnabled = false
            //checkInDatePicker.isHidden = true
            checkOutDatePicker.isEnabled = false
            //checkOutDatePicker.isHidden = true
            numberOfAdultsStepper.isEnabled = false
            numberOfChildrenStepper.isEnabled = false
            wifiSwitch.isEnabled = false
            
            firstNameTextField.text = registration?.firstName
            lastNameTextField.text = registration?.lastName
            emailTextField.text = registration?.emailAddress
            checkInDatePicker.date = (registration?.checkInDate)!
            checkOutDatePicker.date = (registration?.checkOutDate)!
            numberOfAdultsStepper.value = Double((registration?.numberOfAdults)!)
            numberOfChildrenStepper.value = Double((registration?.numberOfChildren)!)
            wifiSwitch.isOn = (registration?.wifi)!
            roomType = registration?.roomType


            cancelButton.isEnabled = false
            
        } else {
        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkInDatePicker.date = midnightToday
        }
        
        updateDateViews()
        updateNumberOfGuests()
        updateRoomType()
        updateRegistrationCharge()
        enableDoneButton()
        
    }


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (checkInDatePickerCellIndexPath.section, checkInDatePickerCellIndexPath.row):
            if isCheckInDatePickerShown {
                return 216.0
            } else{
                return 0.0
            }
        case (checkOutDatePickerCellIndexPath.section, checkOutDatePickerCellIndexPath.row):
            if isCheckOutDatePickerShown {
                return 216.0
            } else{
                return 0.0
            }
        default:
            return 44.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (checkInDatePickerCellIndexPath.section, checkInDatePickerCellIndexPath.row - 1):
            if isCheckInDatePickerShown {
                isCheckInDatePickerShown = false
            }
            else if isCheckOutDatePickerShown  {
                isCheckOutDatePickerShown = false
                isCheckInDatePickerShown = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
            
        case (checkOutDatePickerCellIndexPath.section, checkOutDatePickerCellIndexPath.row - 1):
            if isCheckOutDatePickerShown {
                isCheckOutDatePickerShown = false
            } else if isCheckInDatePickerShown {
                isCheckInDatePickerShown = false
                isCheckOutDatePickerShown = true
            } else {
                isCheckOutDatePickerShown = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()

        default:
            break
        }
    }
 
    
     // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectRoomType" {
            let destinationViewController = segue.destination as? SelectRoomTypeTableViewController
            destinationViewController?.delegate = self
            destinationViewController?.roomType = roomType
        }
    }

    func didSelect(roomType: RoomType) {
        self.roomType = roomType
        updateRoomType()
        updateRegistrationCharge()
        enableDoneButton()
    }
    
    func updateDateViews() {
        let dateFormatter = DateFormatter()
        checkOutDatePicker.minimumDate = checkInDatePicker.date.addingTimeInterval(86400)
        
        dateFormatter.dateStyle = .medium
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
    }
    
    func updateNumberOfGuests() {
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    func updateRoomType() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.name
        } else {
            roomTypeLabel.text = "Not Set"
        }
    }
    
    func enableDoneButton() {
        doneButtonTapped.isEnabled = false
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let hasWifi = wifiSwitch.isOn
        let roomChoice = roomType?.name ?? "Not set"
        if firstName == "" || lastName == "" || email == "" {
            return
        }
        if numberOfAdults == 0 {
            return
        }
        if roomChoice == "Not set" {
            return
        }
        
        registration = Registration(firstName: firstName,
                                    lastName: lastName,
                                    emailAddress: email,
                                    checkInDate: checkInDate,
                                    checkOutDate: checkOutDate,
                                    numberOfAdults: numberOfAdults,
                                    numberOfChildren: numberOfChildren,
                                    roomType: (roomType ?? nil)!,
                                    wifi: hasWifi)
        
        doneButtonTapped.isEnabled = true

    }
    
    func updateRegistrationCharge() {
        var totalCharge: Int = 0
        var totalWifiCharge: Int = 0
        let difference = NSCalendar.current.dateComponents([.day], from: checkInDatePicker.date, to: checkOutDatePicker.date)
        let nightsStay = difference.day ?? 0
        numberOfNightsLabel.text = "\(nightsStay)"
        
        let roomShortName = roomType?.shortName ?? ""
        let roomPrice = roomType?.price ?? 0
        chargeRoomTypeLabel.text = roomShortName + "   " + "$ \(roomPrice)"

        if wifiSwitch.isOn {
            totalWifiCharge = nightsStay * 10
            chargeWifiLabel.text = "Yes   $ \(totalWifiCharge)"
        } else {
            chargeWifiLabel.text = "No charge"
        }

        if roomPrice > 0 {
            totalCharge = (nightsStay * roomPrice) + totalWifiCharge
            chargeTotalLabel.text = "$ \(totalCharge)"
        } else {
            chargeTotalLabel.text = "  "
        }
    }
    
    
    @IBAction func registrationDataChanged(_ sender: Any?) {

        updateRegistrationCharge()
        enableDoneButton()
        
    }
    
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        updateDateViews()
        updateRegistrationCharge()
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuests()
        enableDoneButton()
    }
    
    @IBAction func wifiSwitchChanged(_ sender: UISwitch) {
        updateRegistrationCharge()
    }
   
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
