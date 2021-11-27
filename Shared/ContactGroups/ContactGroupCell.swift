//
//  ContactGroupCell.swift
//  GroupableContacts
//
//  Created by Jing Wei Li on 11/27/21.
//

import SwiftUI

struct ContactGroupCell: View {
    let contactGroup: ContactGroup
    
    var body: some View {
        HStack {
            Image(systemName: "folder.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .padding(5)
            Text(contactGroup.group)
            Spacer()
        }
            .contentShape(Rectangle())
    }
}
