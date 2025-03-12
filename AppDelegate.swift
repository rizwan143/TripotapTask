////
////  AppDelegate.swift
////  TripOTap
////
////  Created by Rizwan Sultan on 10/03/2025.
////
//
//import UIKit
//import CoreData
//import GoogleMaps
//import UserNotifications
//
//@main
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    var window: UIWindow?
//
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        GMSServices.provideAPIKey("AIzaSyBpfz6tBnzlD1lZFyguZT9K9RvB8hEvBfM")
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
//                   if granted {
//                       print("Notification permission granted ✅")
//                       self.requestNotificationPermission()
//                       DispatchQueue.main.async {
//                           UIApplication.shared.registerForRemoteNotifications()
//                       }
//                   } else {
//                       print("Notification permission denied ❌")
//                   }
//               }
//               
//               UNUserNotificationCenter.current().delegate = self
//               
//        // Override point for customization after application launch.
//        return true
//    }
//    func requestNotificationPermission() {
//            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//                if granted {
//                    print("Notification permission granted")
//                } else {
//                    print("Notification permission denied")
//                }
//            }
//        }
//    
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//
//        
//        completionHandler()
//    }
//
//    func navigateToARViewController() {
//        if let navigationController = window?.rootViewController as? UINavigationController {
//            let arVC = ARViewController()
//            navigationController.pushViewController(arVC, animated: true)
//        } else {
//            let arVC = ARViewController()
//            let navController = UINavigationController(rootViewController: arVC)
//            window?.rootViewController = navController
//            window?.makeKeyAndVisible()
//        }
//    }
//
//
//    func applicationWillResignActive(_ application: UIApplication) {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//    }
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//    }
//
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    }
//
//
//}
//
//  AppDelegate.swift
//  TripOTap
//
//  Created by Rizwan Sultan on 10/03/2025.
//

import UIKit
import CoreData
import GoogleMaps
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyBpfz6tBnzlD1lZFyguZT9K9RvB8hEvBfM")
        
        // Request notification permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted ✅")
                self.requestNotificationPermission()
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification permission denied ❌")
            }
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        // Override point for customization after application launch.
        return true
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // Handle the notification action
        navigateToARViewController()
        
        completionHandler()
    }

    func navigateToARViewController() {
        if let navigationController = window?.rootViewController as? UINavigationController {
            let arVC = ARViewController()
            navigationController.pushViewController(arVC, animated: true)
        } else {
            let arVC = ARViewController()
            let navController = UINavigationController(rootViewController: arVC)
            window?.rootViewController = navController
            window?.makeKeyAndVisible()
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
}
