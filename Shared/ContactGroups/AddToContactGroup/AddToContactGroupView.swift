//
//  AddToContactGroupView.swift
//  GroupableContacts
//
//  Created by Jing Wei Li on 11/26/21.
//

import SwiftUI
import Contacts

struct AddToContactGroupView: View {
    let viewModel: AddToContactGroupViewModel
    @State var groupName: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                TextField("Enter Group Name", text: $groupName)
                Section(header: Text("ADD TO EXISTING GROUP")) {
                    ForEach(viewModel.allContactGroups, id: \.group) { contactGroup in
                        ContactGroupCell(contactGroup: contactGroup)
                            .onTapGesture {
                                viewModel.addContact(to: contactGroup)
                                presentationMode.wrappedValue.dismiss()
                            }
                        
                    }
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Add to Contact Group")
            .toolbar(content: {
                ToolbarItemGroup {
                    Button(action: {
                        viewModel.addContact(to: groupName)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Done")
                    }
                }
            })
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
