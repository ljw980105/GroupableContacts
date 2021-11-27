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

struct ContactGroupManager {
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
    
    static var allContactGroups: [ContactGroup] {
        userDefaults
            .dictionaryRepresentation()
            .filter { $0.key.contains("group.")}
            .compactMap { res -> ContactGroup? in
                guard let identifiers = res.value as? [String] else {
                    return nil
                }
                
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
                let contacts = try? contactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
                guard let contacts = contacts else {
                    return nil
                }
                
                return .init(
                    group: res.key.replacingOccurrences(of: "group.", with: ""),
                    contacts: contacts
                )
            }
    }
    
    private static func groupName(for group: String) -> String {
        "group.\(group)"
    }
}
