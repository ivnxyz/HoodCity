//
//  AppDelegate.swift
//  HoodCity
//
//  Created by Iván Martínez on 11/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds
import FBSDKCoreKit
import TwitterKit
import Fabric
import Answers

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Configure Firebase
        FirebaseApp.configure()
        GADMobileAds.configure(withApplicationID: adMobAppId)
        
        // Configure SDK's
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        Twitter.sharedInstance().start(withConsumerKey: twitterConsumerKey, consumerSecret: twitterSecretKey)
        
        Fabric.with([Answers.self, Twitter.self])
        
        // Customize NavigationBar
        let navigationAppearance = UINavigationBar.appearance()
        navigationAppearance.tintColor = UIColor(red: 38/255.0, green: 42/255.0, blue: 152/255.0, alpha: 1)
        
        // Initial ViewController
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let mainViewController: UIViewController!
        
        let currentUser = Auth.auth().currentUser
        
        if currentUser != nil {
            let mapController = MapController()
            let navigationController = UINavigationController(rootViewController: mapController)
            mainViewController = navigationController
        } else {
            let signUpController = SignUpController()
            mainViewController = signUpController
        }
        
        window?.rootViewController = mainViewController
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == "fb1104746023003791" {
            let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
            return handled
        } else {
            return Twitter.sharedInstance().application(app, open: url, options: options)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
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

