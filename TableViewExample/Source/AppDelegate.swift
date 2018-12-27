//
//  AppDelegate.swift
//  TableViewExample
//
//  Created by Scott Gruby on 12/3/18.
//  Copyright © 2018 Scott Gruby. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Setup our view controller. Don't use a storyboard because storyboards seem to get in the way for me.
        let viewController: ExampleTableViewController = ExampleTableViewController()
        let navController: UINavigationController = UINavigationController(rootViewController: viewController)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = navController
        return true
    }
}

