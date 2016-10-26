//
//  UIViewController+MixrAddOns.swift
//  MIXR
//
//  Created by Michael Ciesielka on 9/22/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayCommonAlert(alertMesage : NSString) {
        let alertController = UIAlertController (title: globalConstants.kAppName, message: alertMesage as String?, preferredStyle:.Alert)
        let okayAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alertController.addAction(okayAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
