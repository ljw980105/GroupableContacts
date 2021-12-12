//
//  ContactGroupDetailViewModel.swift
//  GroupableContacts
//
//  Created by Jing Wei Li on 11/27/21.
//

import Foundation
import SwiftUI

class ContactGroupDetailViewModel: ObservableObject {
    let originalContactGroup: ContactGroup
    @Published var contactGroup: ContactGroup = .init(group: "", contacts: [])
    
    init(originalContactGroup: ContactGroup) {
        self.originalContactGroup = originalContactGroup
    }
    
    func getContacts() {
        contactGroup = ContactGroupManager.refreshContactGroup(originalContactGroup)
    }
    
    func deleteContact(at indexSet: IndexSet) {
        let index = indexSet[indexSet.startIndex] as Int
        let contact = contactGroup.contacts[index]
        ContactGroupManager.deleteContact(contact, in: contactGroup)
        
        var newContacts = contactGroup.contacts
        newContacts.remove(atOffsets: indexSet)
        contactGroup = .init(
            group: contactGroup.group,
            contacts: newContacts
        )
    }
}
