//
//  ContactsViewModel.swift
//  GroupableContacts
//
//  Created by Jing Wei Li on 11/26/21.
//

import Foundation
import Contacts
import ContactsUI

class ContactsViewModel: ObservableObject {
    @Published var contacts: [CNContact] = []
    @Published var contactsGroupedByFirstLetter: [ContactsGroupedByFirstLetter] = []
    
    init() {
        contacts = getContacts()
        contactsGroupedByFirstLetter = contacts
            .sortedGroupByAlphabetical
            .sorted(by: { $0.letter < $1.letter })
    }
    
    private func getContacts() -> [CNContact] {
        let contactStore = CNContactStore()
        let keysToFetch: [CNKeyDescriptor] = [
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactImageDataKey
        ].map { $0 as CNKeyDescriptor }
        + [CNContactViewController.descriptorForRequiredKeys()]
        let containerId = contactStore.defaultContainerIdentifier()
        let predicate: NSPredicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
        let contacts = try? contactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
        return (contacts ?? [])
            .sorted(by: { $0.givenName < $1.givenName })
    }
}
