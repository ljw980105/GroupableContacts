//
//  ContactDetailView.swift
//  GroupableContacts
//
//  Created by Jing Wei Li on 11/26/21.
//

import Foundation
import Contacts
import ContactsUI
import SwiftUI

struct ContactDetailView: UIViewControllerRepresentable {
    typealias UIViewControllerType = CNContactViewController
    let contact: CNContact
    
    func makeUIViewController(context: Context) -> CNContactViewController {
        .init(for: contact)
    }
    
    func updateUIViewController(_ uiViewController: CNContactViewController, context: Context) {
        
    }
}
