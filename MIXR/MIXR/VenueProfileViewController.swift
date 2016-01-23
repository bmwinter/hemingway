//
//  VenueProfileViewController.swift
//  MIXR
//
//  Created by Brendan Winter on 10/2/15.
//  Copyright (c) 2015 MIXR LLC. All rights reserved.
//

import UIKit

class VenueProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackClicked(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}

