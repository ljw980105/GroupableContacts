//
//  ContactsCell.swift
//  GroupableContacts
//
//  Created by Jing Wei Li on 11/26/21.
//

import Foundation
import SwiftUI
import Contacts

enum ContactsCellStyles {
    static var profileImageWidth: CGFloat { 40.0 }
    static var profileImageHeight: CGFloat { 40.0 }
    static var profileImagePadding: CGFloat { 2.0 }
}

struct ContactsCell: View {
    let contact: CNContact
    
    var body: some View {
        HStack {
            profileImageView(for: contact.image)
                .resizable()
                .frame(
                    width: ContactsCellStyles.profileImageWidth,
                    height: ContactsCellStyles.profileImageHeight
                )
                .padding(ContactsCellStyles.profileImagePadding)
            VStack(alignment: .leading) {
                Text(contact.name)
            }
        }
    }
    
    func profileImageView(for image: UIImage?) -> Image {
        guard let image = image else { return Image(systemName: "person.circle.fill") }
        return Image(uiImage: image)
    }
}
