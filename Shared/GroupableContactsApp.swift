//
//  GroupableContactsApp.swift
//  Shared
//
//  Created by Jing Wei Li on 11/26/21.
//

import SwiftUI

@main
struct GroupableContactsApp: App {
    var body: some Scene {
        WindowGroup {
            if PermissionEvaluator.isPermissionGranted {
                TabView {
                    ContactsView()
                        .tabItem {
                            Image(systemName: "phone.fill")
                            Text("Contacts")
                        }
                    Text("Groups")
                        .tabItem {
                            Image(systemName: "folder.fill")
                            Text("Groups")
                        }
                }
                    
            } else {
                PermissionsView()
            }
        }
    }
}
