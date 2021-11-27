//
//  ContentView.swift
//  Shared
//
//  Created by Jing Wei Li on 11/26/21.
//

import SwiftUI
import UIKit
import Contacts

struct ContactsView: View {
    @ObservedObject var viewModel = ContactsViewModel()
    @State var isAddingToGroup = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.contactsGroupedByFirstLetter, id: \.letter) { group in
                    Section(header: Text(group.letter)) {
                        ForEach(group.contacts, id: \.identifier) { contact in
                            NavigationLink(destination: ContactDetailView(contact: contact)) {
                                ContactsCell(contact: contact)
                                    .contextMenu {
                                        Button {
                                            viewModel.contactForGroup = contact
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                isAddingToGroup = true
                                            }
                                        } label: {
                                            Label("Add to Group", systemImage: "plus.circle")
                                        }
                                    }
                            }
                        }
                    }
                    
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Contacts")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isAddingToGroup) {
                if let contact = viewModel.contactForGroup {
                    AddToContactGroupView(viewModel: .init(contact: contact))
                        .onDisappear {
                            isAddingToGroup = false
                        }
                }
            }
        }
    }
}
