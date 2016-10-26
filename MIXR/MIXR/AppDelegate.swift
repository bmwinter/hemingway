//
//  AppDelegate.swift
//  MIXR
//
//  Created by Brendan Winter on 10/2/15.
//  Copyright (c) 2015 MIXR LLC. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldToolbarUsesTextFieldTintColor = true
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        AppPersistedStore.sharedInstance.persist()
    }
}

extension AppDelegate {
    var visibleViewController: UIViewController? {
        return getVisibleViewControllerFrom(window?.rootViewController)
    }
    
    private func getVisibleViewControllerFrom(viewController: UIViewController?) -> UIViewController? {
        if let navigationViewController = viewController as? UINavigationController {
            return getVisibleViewControllerFrom(navigationViewController.visibleViewController)
        } else if let tabBarController = viewController as? UITabBarController {
            return getVisibleViewControllerFrom(tabBarController.selectedViewController)
        } else if let presentedViewController = viewController?.presentedViewController {
            return getVisibleViewControllerFrom(presentedViewController)
        } else {
            return viewController
        }
    }
}
