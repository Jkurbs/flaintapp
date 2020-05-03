//
//  AppDelegate.swift
//  Flaint
//
//  Created by Kerby Jean on 4/20/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import Firebase
import Network
import IQKeyboardManager
import FBAllocationTracker
import FBMemoryProfiler


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let monitor = NWPathMonitor()
    var handle: AuthStateDidChangeListenerHandle?
    var profileVC: ProfileVC?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
          
        FBAllocationTrackerManager.shared()?.startTrackingAllocations()
        FBAllocationTrackerManager.shared()?.enableGenerations()
        
        let memoryProfiler = FBMemoryProfiler()
        memoryProfiler.isEnabled = true
 
       let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
       UserDefaults.standard.set(currentCount + 1, forKey: "launchCount")
       configure()
       customize()
       observeAuthorisedState()
       return true
    }
    
    
    func observeAuthorisedState() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            if user == nil {
                self.setupRootViewController(viewController: AuthVC())
            } else {
                DispatchQueue.main.async {
                    self.profileVC = ProfileVC()
                    self.profileVC?.userUID = user?.uid
                     AuthService.shared.UserID = user?.uid
                     UserDefaults.standard.set(user?.uid, forKey: .userId)
                    self.setupRootViewController(viewController: self.profileVC!)
                    self.profileVC = nil
                }
            }
            Auth.auth().removeStateDidChangeListener(self.handle!)
        }
    }
    
    private func setupRootViewController(viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }

    
    @available(iOS 13.0, *)
    func customize() {
                
        self.window?.rootViewController?.view.overrideUserInterfaceStyle = .light
        
        let color = UIColor.label
        UINavigationBar.appearance().tintColor = color
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().backgroundColor = .systemBackground
        UINavigationBar.appearance().barTintColor = .systemBackground
        UINavigationBar.appearance().isTranslucent = false
        
        UIToolbar.appearance().tintColor = .label
        UIToolbar.appearance().backgroundColor = .systemBackground
        UIToolbar.appearance().clipsToBounds = true
        UIToolbar.appearance().isTranslucent = true


        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor(white: 0.8, alpha: 1.0)
        pageControl.currentPageIndicatorTintColor = UIColor(white: 0.6, alpha: 1.0)
        
        IQKeyboardManager.shared().isEnabled = true
    }
    
    func configure() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                print("No connection.")
                DispatchQueue.main.async {
                    self.window?.rootViewController?.showMessage("No connection", type: .warning)
                }
            }
            print(path.isExpensive)
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
    }
    
    
    // MARK: - State Restoration
    
    func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
        true
    }
    
    func application(_ application: UIApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool {
        true
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token to auth
        Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.prod)
        // Further handling of the device token if needed by the app
        // ...
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification notification: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(notification) {
            completionHandler(UIBackgroundFetchResult.noData)
            return
        }
        // This notification is not auth related, developer should handle it.
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        if Auth.auth().canHandle(url) {
            return true
        }
        // URL not auth related, developer should handle it.
        return false
    }
    
    // For iOS 8-
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if Auth.auth().canHandle(url) {
            return true
        }
        // URL not auth related, developer should handle it.
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("BACKGROUND")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
