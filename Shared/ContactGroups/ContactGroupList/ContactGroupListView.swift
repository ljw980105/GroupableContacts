//
//  ContactGroupListView.swift
//  GroupableContacts
//
//  Created by Jing Wei Li on 11/27/21.
//

import SwiftUI

struct ContactGroupListView: View {
    @ObservedObject var viewModel = ContactGroupListViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.allContactGroups, id: \.group) { contactGroup in
                    NavigationLink(
                        destination: ContactGroupDetailView(
                            viewModel: .init(originalContactGroup: contactGroup)
                        )) {
                        ContactGroupCell(contactGroup: contactGroup)
                    }
                }
                .onDelete { indexSet in
                    viewModel.deleteContact(at: indexSet)
                }
            }
            .navigationTitle("Contact Groups")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.getContacts()
            }
        }
    }
}
