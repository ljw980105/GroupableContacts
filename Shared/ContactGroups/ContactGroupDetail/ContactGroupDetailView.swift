//
//  ContactGroupDetailView.swift
//  GroupableContacts
//
//  Created by Jing Wei Li on 11/27/21.
//

import SwiftUI

struct ContactGroupDetailView: View {
    let contactGroup: ContactGroup
    
    var body: some View {
        List {
            ForEach(contactGroup.contacts, id: \.identifier) { contact in
                NavigationLink(destination: ContactDetailView(contact: contact)) {
                    ContactsCell(contact: contact)
                }
            }
        }
        .navigationTitle(contactGroup.group)
        .navigationBarTitleDisplayMode(.inline)
    }
}
