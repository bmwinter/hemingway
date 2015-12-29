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

    let forgottenFuturistRegular = UIFont(name: "ForgottenFuturistRg-Regular", size: 24)
    let forgottenFuturistBold = UIFont(name: "ForgottenFuturistRg-Bold", size: 24)
    let forgottenFuturistBoldItalic = UIFont(name: "ForgottenFuturistRg-BoldItalic", size: 24)
    
    var window: UIWindow?
    var navigationController : UINavigationController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldToolbarUsesTextFieldTintColor = true
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

/*
@todo- Sujal 

1) the user/venue feed (which is the first tab bar item), i.e - MIXR feed.png  ,MIXR following page.png
2) the list of followers (which is viewed via the Notifications navigation item),  i.e MIXRNEWnotismixrfollowing-01
3) search feed displaying users, venues, etc. (search by phone & name of user or venue) i.e Attachment-1.png
*/