//
//  ContactsViewModel.swift
//  GroupableContacts
//
//  Created by Jing Wei Li on 11/26/21.
//

import Foundation
import Contacts
import ContactsUI
import Combine
import SwiftUI

class ContactsViewModel: ObservableObject {
    @Published var contacts: [CNContact] = []
    @Published var contactsGroupedByFirstLetter: [ContactsGroupedByFirstLetter] = []
    var originalContacts: [ContactsGroupedByFirstLetter] = []
    var contactForGroup: CNContact? = nil
    var searchSubject = PassthroughSubject<String, Never>()
    var indexListSubject = PassthroughSubject<(String, ScrollViewProxy), Never>()
    var disposeBag = [AnyCancellable]()
    var indexList: [String] = []
    private let selectionFeedback = UISelectionFeedbackGenerator()
    private var letterToId: [String: String] = [:]
    
    init() {
        contacts = getContacts()
        contactsGroupedByFirstLetter = contacts
            .sortedGroupByAlphabetical
            .sorted(by: { $0.letter < $1.letter })
        indexList = contactsGroupedByFirstLetter.map { $0.letter }
        originalContacts = contactsGroupedByFirstLetter
        selectionFeedback.prepare()
        
        contactsGroupedByFirstLetter.forEach { group in
            letterToId[group.letter] = group.contacts.first?.identifier ?? ""
        }
        
        searchSubject
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink { str in
                if str.isEmpty {
                    self.contactsGroupedByFirstLetter = self.originalContacts
                } else {
                    let filteredContacts = self.contacts
                        .filter { $0.name.starts(with: str) }
                    if let firstLetterChar = filteredContacts.first?.name.first {
                        let firstLetter = String(firstLetterChar)
                        self.contactsGroupedByFirstLetter = [
                            .init(letter: firstLetter, contacts: filteredContacts)
                        ]
                    }
                }
            }
            .store(in: &disposeBag)
        
        indexListSubject
            .debounce(for: .milliseconds(50), scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink { index, proxy in
                let id = self.letterToId[index] ?? ""
                proxy.scrollTo(id, anchor: .top)
                self.selectionFeedback.selectionChanged()
            }
            .store(in: &disposeBag)
    }
    
    func scrollToSection(_ index: String, proxy: ScrollViewProxy) {
        indexListSubject.send((index, proxy))
    }
    
    private func getContacts() -> [CNContact] {
        let contactStore = CNContactStore()
        let keysToFetch: [CNKeyDescriptor] = [
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactImageDataKey
        ].map { $0 as CNKeyDescriptor }
        + [CNContactViewController.descriptorForRequiredKeys()]
        let containerId = contactStore.defaultContainerIdentifier()
        let predicate: NSPredicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
        let contacts = try? contactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
        return (contacts ?? [])
            .sorted(by: { $0.givenName < $1.givenName })
    }
    
    func processSearch(searchText: String) {
        searchSubject.send(searchText)
    }
}
