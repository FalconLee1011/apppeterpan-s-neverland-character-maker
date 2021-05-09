//
//  AppDelegate.swift
//  firebase-test
//
//  Created by falcon on 2021/6/14.
//

import UIKit
import Firebase
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    FirebaseApp.configure()
    
    return true
  }
}
