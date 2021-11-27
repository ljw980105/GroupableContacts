//
//  PermissionsView.swift
//  GroupableContacts
//
//  Created by Jing Wei Li on 11/26/21.
//

import Foundation
import SwiftUI
import Combine

struct PermissionsView: View {
    @ObservedObject var viewModel = PermissionsViewModel()
    @State var permissionGranted: Bool = false

    var body: some View {
        NavigationView {
            Text("Grant Permission")
                .padding()
                .onAppear {
                    viewModel.requestPermission {
                        self.permissionGranted = $0
                    }
                }
            NavigationLink(
                destination: ContactsView(),
                isActive: $permissionGranted
            ) {}
        }
    }
}
