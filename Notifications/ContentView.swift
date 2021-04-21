//
//  ContentView.swift
//  Notifications
//
//  Created by Jonathan Aanesen on 29/09/2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("iPhone")
                .padding()
            Button(action: { SendNormalNotification(timeInterval: 5) }) {
                Text("Deliver notification in 5 sec")
            }
            Spacer()
            Button(action: { SendActionNotification(timeInterval: 5) }) {
                Text("Deliver notification with actions")
            }
        }
        .frame(height: 150, alignment: .center)
        .onAppear(perform: NotificationHandler)
    }
}

// MARK: - Action Notification

func SendActionNotification(timeInterval: Double) {
    // Define the custom actions.
    let firstAction = UNNotificationAction(identifier: "FIRST_ACTION",
                                           title: "1. action",
                                           options: UNNotificationActionOptions(rawValue: 0))
    let secondAction = UNNotificationAction(identifier: "SECOND_ACTION",
                                            title: "2. action",
                                            options: UNNotificationActionOptions(rawValue: 0))
    let thirdAction = UNNotificationAction(identifier: "THIRD_ACTION",
                                           title: "...",
                                           options: UNNotificationActionOptions(rawValue: 0))
    // Define the notification type
    let meetingInviteCategory =
        UNNotificationCategory(identifier: "ACTION_OPTIONS",
                               actions: [firstAction, secondAction, thirdAction],
                               intentIdentifiers: [],
                               hiddenPreviewsBodyPlaceholder: "",
                               options: .customDismissAction)
    // Register the notification type.
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.setNotificationCategories([meetingInviteCategory])

    let content = UNMutableNotificationContent()
    content.title = "Test Action Notification"
    content.body = "This notification allows the user to answer without opening the application"
    content.categoryIdentifier = "ACTION_OPTIONS"
    content.sound = UNNotificationSound.default

    // Create the trigger as a repeating event.
    let trigger = UNTimeIntervalNotificationTrigger(
        timeInterval: timeInterval, repeats: false)

    // Create the request
    let uuidString = UUID().uuidString
    let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

    // Schedule the request with the system.
    notificationCenter.add(request) { error in
        if error != nil {
            // Handle any errors.
            print("Error occured while delivering notifications to center")
        } else {
            print("Successfully delivered notifications to center")
        }
    }

    return
}

// MARK: - Normal Notification

func SendNormalNotification(timeInterval: Double) {
    // Create the content
    let content = UNMutableNotificationContent()
    content.title = "Notification title"
    content.body = "Notification body"
    content.sound = UNNotificationSound.defaultCritical

    // Create the trigger
    let trigger = UNTimeIntervalNotificationTrigger(
        timeInterval: timeInterval, repeats: false)

    // Create the request
    let uuidString = UUID().uuidString
    let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

    // Schedule the request with the system.
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.add(request) { error in
        if error != nil {
            // Handle any errors.
            print("Error occured while delivering notifications to center")
        } else {
            print("Successfully delivered notifications to center")
        }
    }
    return
}

// MARK: - Notification Authorization

func NotificationHandler() {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound, .badge]) { _, error in

        if error != nil {
            print("*** Notification authorization failed ***")
        }

        // Enable or disable features based on the authorization.
    }
    center.getNotificationSettings { settings in
        guard (settings.authorizationStatus == .authorized) ||
            (settings.authorizationStatus == .provisional) else { return }
    }
}
