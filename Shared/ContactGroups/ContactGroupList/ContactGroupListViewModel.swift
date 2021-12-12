//
//  ContactGroupListViewModel.swift
//  GroupableContacts
//
//  Created by Jing Wei Li on 11/27/21.
//

import Foundation
import SwiftUI

class ContactGroupListViewModel: ObservableObject {
    @Published var allContactGroups: [ContactGroup] = []

    func getContacts() {
        allContactGroups = ContactGroupManager
            .allContactGroups
            .sorted { $0.group < $1.group }
    }
    
    func deleteContact(at indexSet: IndexSet) {
        let index = indexSet[indexSet.startIndex] as Int
        let contact = allContactGroups[index]
        ContactGroupManager.deleteContactGroup(contact)
        allContactGroups.remove(atOffsets: indexSet)
    }
    
}
