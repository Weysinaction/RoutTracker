//
//  AppDelegate.swift
//  RoutTracker
//
//  Created by Владислав Лазарев on 29.09.2021.
//

import UIKit
import GoogleMaps
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyBDi8XIyE96TmWdxa2pLEpOKY8_cTa7BfY")
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else { return }
            self.addNotifications()
        }
        return true
    }

    private func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(pushNotification), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushNotification), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    private func makeNotificationContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        
        content.title = "Пора посмотреть маршрут"
        content.body = "Самое время поискать новые места для посещений"
        content.badge = 1
        return content
    }
    
    private func makeIntervalNotificationTrigger() -> UNNotificationTrigger {
        let minutes = 30
        let seconds = 60
        return UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(minutes * seconds),
                                                 repeats: false)
    }
    
    private func sendNotificationRequest(content: UNNotificationContent, trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: "reminder",
                                            content: content,
                                            trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            guard let error = error else { return }
            print(error.localizedDescription)
        }
    }
    
    @objc private func pushNotification() {
        self.sendNotificationRequest(content: self.makeNotificationContent(),
                                         trigger: self.makeIntervalNotificationTrigger())
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

