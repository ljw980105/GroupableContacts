//
//  ContactGroupDetailView.swift
//  GroupableContacts
//
//  Created by Jing Wei Li on 11/27/21.
//

import SwiftUI

struct ContactGroupDetailView: View {
    @ObservedObject var viewModel: ContactGroupDetailViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.contactGroup.contacts, id: \.identifier) { contact in
                NavigationLink(destination: ContactDetailView(contact: contact)) {
                    ContactsCell(contact: contact)
                }
            }
            .onDelete { indexSet in
                viewModel.deleteContact(at: indexSet)
            }
        }
        .onAppear {
            viewModel.getContacts()
        }
        .navigationTitle(viewModel.contactGroup.group)
        .navigationBarTitleDisplayMode(.inline)
    }
}
