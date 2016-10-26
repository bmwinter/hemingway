//
//  MXNavigationBarTrait.swift
//  MIXR
//
//  Created by Michael Ciesielka on 10/10/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

enum MXBarButtonType {
    case None
    case Notification
    case Camera
    case Back
}

protocol MXNavigationBarTrait: class {
    func setupNavigationBar()
    
    func shouldHideNavigationBar() -> Bool
    func shouldUseDefaultImage() -> Bool
    func leftBarButtonType() -> MXBarButtonType
    func rightBarButtonType() -> MXBarButtonType
}

extension MXNavigationBarTrait {
    
    func shouldUseDefaultImage() -> Bool {
        return true
    }
    
    func leftBarButtonType() -> MXBarButtonType {
        return .Notification
    }
    
    func rightBarButtonType() -> MXBarButtonType {
        return .Camera
    }
}
