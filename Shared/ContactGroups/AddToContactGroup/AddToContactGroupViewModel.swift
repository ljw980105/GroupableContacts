//
//  AddToContactGroupViewModel.swift
//  GroupableContacts
//
//  Created by Jing Wei Li on 11/26/21.
//

import Foundation
import SwiftUI
import Contacts

class AddToContactGroupViewModel {
    let contact: CNContact
    @Published var allContactGroups: [ContactGroup]
    
    init(contact: CNContact) {
        allContactGroups = ContactGroupManager.allContactGroups
        self.contact = contact
    }
    
    func addContact(to group: String) {
        if !group.isEmpty {
            ContactGroupManager.addContact(contact, to: group)
        }
    }
    
    func addContact(to group: ContactGroup) {
        ContactGroupManager.addContact(contact, to: group.group)
    }
}
