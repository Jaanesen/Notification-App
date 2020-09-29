//
//  NotificationsApp.swift
//  Notifications WatchKit Extension
//
//  Created by Jonathan Aanesen on 29/09/2020.
//

import SwiftUI

@main
struct NotificationsApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
