//
//  RegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Seng Hwwa on 11/01/2019.
//  Copyright © 2019 senghwabeh. All rights reserved.
//

import UIKit

class RegistrationTableViewController: UITableViewController {

    var registrations: [Registration] = []
    var registrationMode: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return registrations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationCell", for: indexPath)
        
        let registration = registrations[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        cell.textLabel?.text = registration.firstName + " " + registration.lastName
        cell.detailTextLabel?.text = dateFormatter.string(from: registration.checkInDate) + " - " + dateFormatter.string(from: registration.checkOutDate) + " : " + registration.roomType.name
        
        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let addRegistrationTableViewController = segue.destination as? AddRegistrationTableViewController else {return}
        if segue.identifier == "AddRegistration" {
            registrationMode = "ADD"
            addRegistrationTableViewController.tableMode = registrationMode
        } else {
            registrationMode = "VIEW"
            addRegistrationTableViewController.tableMode = registrationMode
            addRegistrationTableViewController.title = "View Registration Details"
            if let indexPath = tableView.indexPathForSelectedRow {
                addRegistrationTableViewController.registration = registrations[indexPath.row]
            }
        }
    }
    

    @IBAction func unwindFromAddRegistration(unwindSegue: UIStoryboardSegue) {
        print("Unwound")
        guard let addRegistrationViewController = unwindSegue.source as? AddRegistrationTableViewController,
            let registration = addRegistrationViewController.registration else {return}
        if registrationMode == "ADD" {
            print("Adding registration")
            registrations.append(registration)
            tableView.reloadData()
        } else {
            print ("Not adding registration")
        }
    }
    
}
