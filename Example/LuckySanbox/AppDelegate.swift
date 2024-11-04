//
//  AppDelegate.swift
//  LuckySanbox
//
//  Created by Lucky on 10/12/2024.
//  Copyright (c) 2024 Lucky. All rights reserved.
//

import UIKit
import LuckySanbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: SanboxController())
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        return true
    }


}

