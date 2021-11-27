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
        allContactGroups = ContactGroupManager.allContactGroups
    }
    
}
