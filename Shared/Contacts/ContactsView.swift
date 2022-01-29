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
    @State private var searchText = ""
    @State var selectedIndex: String = ""
    
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                VStack {
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
                    .searchable(text: $searchText, prompt: "Search for Contacts")
                    .onChange(of: searchText) { searchText in
                        viewModel.processSearch(searchText: searchText)
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
                .overlay(
                    IndexListView(
                        indexList: viewModel.indexList,
                        selectedIndex: $selectedIndex
                    )
                        .opacity(searchText.isEmpty ? 1 : 0)
                        .onChange(of: selectedIndex) { index in
                            viewModel.scrollToSection(index, proxy: proxy)
                        }
                    ,
                    alignment: .trailing
                )
            }
        }
    }
}
