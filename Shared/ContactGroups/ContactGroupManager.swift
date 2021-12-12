//
//  ContactGroupManager.swift
//  GroupableContacts
//
//  Created by Jing Wei Li on 11/26/21.
//

import Foundation
import Contacts
import ContactsUI

struct ContactGroup {
    let group: String
    let contacts: [CNContact]
}

enum ContactGroupManager {
    private static var userDefaults: UserDefaults { UserDefaults.standard }
    
    static func addContact(_ contact: CNContact, to group: String) {
        let groupName = groupName(for: group)
        if let groups = userDefaults.array(forKey: groupName) as? [String] {
            let newGroup = groups + [contact.identifier]
            userDefaults.set(newGroup, forKey: groupName)
        } else {
            userDefaults.set([contact.identifier], forKey: groupName)
        }
    }
    
    static func deleteContactGroup(_ group: ContactGroup) {
        userDefaults.removeObject(forKey: groupName(for: group.group))
    }
    
    static func deleteContact(_ contact: CNContact, in group: ContactGroup) {
        guard let index = group.contacts.firstIndex(of: contact) else { return }
        var newContacts = group.contacts
        newContacts.remove(at: index)
        userDefaults.set(
            newContacts.map { $0.identifier },
            forKey: groupName(for: group.group)
        )
    }
    
    static var allContactGroups: [ContactGroup] {
        userDefaults
            .dictionaryRepresentation()
            .filter { $0.key.contains("group.")}
            .compactMap { res -> ContactGroup? in
                guard let identifiers = res.value as? [String],
                    let contacts = mapIdentifiersToContacts(identifiers) else {
                    return nil
                }
                return .init(
                    group: res.key.replacingOccurrences(of: "group.", with: ""),
                    contacts: contacts
                )
            }
    }
    
    /// Refresh the contact group in the event that its contacts have changed
    static func refreshContactGroup(_ contactGroup: ContactGroup) -> ContactGroup {
        let key = groupName(for: contactGroup.group)
        guard let identifiers = userDefaults.stringArray(forKey: key),
            let contacts = mapIdentifiersToContacts(identifiers) else {
                return contactGroup
            }
        return .init(group: contactGroup.group, contacts: contacts)
    }
    
    // MARK: - Private
    
    private static func mapIdentifiersToContacts(_ identifiers: [String]) -> [CNContact]? {
        let contactStore = CNContactStore()
        let keysToFetch: [CNKeyDescriptor] = [
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactImageDataKey
        ].map { $0 as CNKeyDescriptor }
        + [CNContactViewController.descriptorForRequiredKeys()]
        let predicate: NSPredicate = CNContact.predicateForContacts(withIdentifiers: identifiers)
        return try? contactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
    }
    
    private static func groupName(for group: String) -> String {
        "group.\(group)"
    }
}
