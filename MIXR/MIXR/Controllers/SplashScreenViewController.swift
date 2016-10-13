//
//  SplashScreenViewController.swift
//  MIXR
//
//  Created by Nilesh Patel on 10/04/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import Foundation
import UIKit
class SplashScreenViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(SplashScreenViewController.PushLoginVC), userInfo: nil, repeats: false)

    }
    
    func PushLoginVC(){
        self.performSegueWithIdentifier("LoginSegue", sender: nil)
    }
}

extension SplashScreenViewController {
    override func shouldHideNavigationBar() -> Bool {
        return true
    }
}
