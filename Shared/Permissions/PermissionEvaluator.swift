//
//  PermissionEvaluator.swift
//  GroupableContacts
//
//  Created by Jing Wei Li on 11/26/21.
//

import Foundation
import Contacts
import Combine

enum PermissionEvaluator {
    static var isPermissionGranted: Bool {
        CNContactStore.authorizationStatus(for: .contacts) == .authorized
    }
    
    static func requestPermission() -> AnyPublisher<Bool, Error> {
        Future<Bool, Error> { promise in
            CNContactStore().requestAccess(for: .contacts) { success, error in
                if let error = error {
                    promise(.failure(error))
                } else if success {
                    promise(.success(true))
                } else {
                    promise(.failure("Unknown error"))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

extension String: Error {}

extension String: LocalizedError {
    public var errorDescription: String? {
        self
    }
}

