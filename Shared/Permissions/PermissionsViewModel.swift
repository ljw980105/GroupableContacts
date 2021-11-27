//
//  PermissionsViewModel.swift
//  GroupableContacts
//
//  Created by Jing Wei Li on 11/26/21.
//

import Foundation
import Combine
import SwiftUI

class PermissionsViewModel: ObservableObject {
    var disposeBag: Set<AnyCancellable> = Set()
    
    func requestPermission(statusChanged: @escaping (Bool) -> Void) {
        PermissionEvaluator.requestPermission()
            .sink(receiveCompletion: { completion in
                
            }, receiveValue: { success in
                statusChanged(success)
            })
            .store(in: &disposeBag)
    }
}
