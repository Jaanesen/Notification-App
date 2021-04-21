//
//  ContentView.swift
//  Notifications WatchKit Extension
//
//  Created by Jonathan Aanesen on 29/09/2020.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    
    var body: some View {
        VStack {
            Text("Apple Watch")
                .padding()
            Button(action: { SendNormalNotification(timeInterval: 5) }) {
                Text("Deliver notification in 5 sec")
            }
            Spacer()
        }
        .onAppear(perform: NotificationHandler)
    }
}

func SendNormalNotification(timeInterval: Double) {
    let content = UNMutableNotificationContent()
    content.title = "Test notification"
    content.body = "This is the notification body"
    content.sound = UNNotificationSound.default
    
    // Create the trigger as a repeating event.
    let trigger = UNTimeIntervalNotificationTrigger(
        timeInterval: timeInterval, repeats: false)
    
    // Create the request
    let uuidString = UUID().uuidString
    let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
    
    
    // Schedule the request with the system.
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.add(request) { (error) in
        if error != nil {
            // Handle any errors.
            print("Error occured while delivering notifications to center")
        } else {
            print("Successfully delivered notifications to center")
        }
    }
    
    return
}

func NotificationHandler() {
    let center = UNUserNotificationCenter.current()
    center.getNotificationSettings { settings in
        guard (settings.authorizationStatus == .authorized) ||
                (settings.authorizationStatus == .provisional) else { return }
    }
}
