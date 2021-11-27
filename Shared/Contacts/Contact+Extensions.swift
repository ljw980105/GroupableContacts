//
//  Contact.swift
//  GroupableContacts
//
//  Created by Jing Wei Li on 11/26/21.
//

import Foundation
import Contacts
import UIKit

struct EmailAddress {
    let label: String?
    let value: String?
    
    var full: String {
        "\(label ?? "") \(value ?? "")"
    }
}

extension CNContact {
    var emailAddresses2: [EmailAddress] {
        emailAddresses
            .compactMap { EmailAddress(label: $0.label as String?, value: $0.value as String?) }
    }
    
    var image: UIImage? {
        if let imageData = imageData, let image = UIImage(data: imageData) {
            return image
        } else {
            return nil
        }
    }
    
    var name: String {
        "\(givenName) \(familyName)"
    }
}

struct ContactsGroupedByFirstLetter {
    let letter: String
    let contacts: [CNContact]
}

extension Array where Element == CNContact {
    var sortedGroupByAlphabetical: [ContactsGroupedByFirstLetter] {
        var sectionedData: [String: [CNContact]] = [:]
        forEach { contact in
            guard let firstLetter = contact.givenName.first else {
                sectionedData["#"] = (sectionedData["#"] ?? []) + [contact]
                return
            }
            let firstLetterStr = String(firstLetter)
            sectionedData[firstLetterStr] = (sectionedData[firstLetterStr] ?? []) + [contact]
        }
        return sectionedData.map { key, value -> ContactsGroupedByFirstLetter in
                .init(letter: key, contacts: value)
        }
    }
}
