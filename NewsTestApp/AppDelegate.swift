//
//  AppDelegate.swift
//  NewsTestApp
//
//  Created by Вячеслав on 08/03/2020.
//  Copyright © 2020 PaRaDoX. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        _ = NTADatabaseManager.sharedInstance
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        navigationController.navigationBar.tintColor = #colorLiteral(red: 0.8862745098, green: 0.368627451, blue: 0, alpha: 1)
        navigationController.viewControllers = [NTANewsViewController()]
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

}

