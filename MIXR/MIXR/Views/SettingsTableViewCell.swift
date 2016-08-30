//
//  SettingsTableViewCell.swift
//  MIXR
//
//  Created by Michael Ciesielka on 8/29/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    var setting: String? {
        set {
            settingLabel?.text = newValue
        }
        get {
            return settingLabel?.text
        }
    }

    @IBOutlet private weak var settingLabel: UILabel?
}
