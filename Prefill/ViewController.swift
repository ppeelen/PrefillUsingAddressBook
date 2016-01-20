//
//  ViewController.swift
//  Prefill
//
//  Created by Paul Peelen on 2016-01-20.
//  Copyright © 2016 Dashbox. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController {
    
    @IBOutlet weak var nameFirst: UILabel!
    @IBOutlet weak var nameLast: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phoneNo: UILabel!
    @IBOutlet weak var address: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getContact(sender: AnyObject) {
        getMe()
    }

}

extension ViewController {
    
    /**
     Search the addressbook for the contact
     */
    private func getMe() {
        let ownerName = getOwnerName()
        let store = CNContactStore()
        
        do {
            // Ask permission from the addressbook and search for the user using the owners name
            let contacts = try store.unifiedContactsMatchingPredicate(CNContact.predicateForContactsMatchingName(ownerName), keysToFetch:[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactPostalAddressesKey, CNContactEmailAddressesKey])
            
            //assuming contain at least one contact
            if let contact = contacts.first {
                // Checking if phone number is available for the given contact.
                if (contact.isKeyAvailable(CNContactPhoneNumbersKey)) {
                    // Populate the fields
                    populateUsingContact(contact)
                } else {
                    //Refetch the keys
                    let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactPostalAddressesKey, CNContactEmailAddressesKey]
                    let refetchedContact = try store.unifiedContactWithIdentifier(contact.identifier, keysToFetch: keysToFetch)
                    
                    // Populate the fields
                    populateUsingContact(refetchedContact)
                }
            }
        } catch let e as NSError {
            print(e.localizedDescription)
        }
        
    }
    
    /**
     Get the device owners name
     
     - returns: The owners name
     */
    private func getOwnerName() -> String {
        // Get the device owners name
        var ownerName = UIDevice.currentDevice().name.trimmedString.stringByReplacingOccurrencesOfString("'", withString: "")
        // Get the model of the device
        let model = UIDevice.currentDevice().model
        
        // Remove the device name from the owners name
        if let t = ownerName.rangeOfString("s \(model)") {
            ownerName = ownerName.substringToIndex(t.startIndex)
        }
        
        return ownerName.trimmedString
    }
    
    /**
     Populate the fields using a contact
     
     - parameter contact: The contact to use
     */
    private func populateUsingContact(contact: CNContact) {
        // Set the name fields
        nameFirst.text = contact.givenName
        nameLast.text = contact.familyName
        
        // Check if there is an address available, it might be empty
        if contact.isKeyAvailable(CNContactPostalAddressesKey) {
            if let
                addrv = contact.postalAddresses.first,
                addr = addrv.value as? CNPostalAddress where addrv.value is CNPostalAddress
            {
                let address = "\(addr.street)\n\(addr.postalCode) \(addr.city)\n\(addr.country)"
                self.address.text = address
            }
        }
        
        // Check if there is a phonenumber available, it might be empty
        if contact.isKeyAvailable(CNContactPhoneNumbersKey) {
            if let
                phonenumberValue = contact.phoneNumbers.first,
                pn = phonenumberValue.value as? CNPhoneNumber where phonenumberValue.value is CNPhoneNumber
            {
                phoneNo.text = pn.stringValue
            }
        }
        
        if contact.isKeyAvailable(CNContactEmailAddressesKey) {
            if let emailValue = contact.emailAddresses.first?.value as? String {
                email.text = emailValue
            }
        }
    }
    
}