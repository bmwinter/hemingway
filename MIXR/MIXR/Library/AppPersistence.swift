//
//  AppPersistence.swift
//  MIXR
//
//  Created by Michael Ciesielka on 9/25/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import UIKit

let kPersistenceMapKey = "kAttrsMapKey"

protocol PersistedStore: class {
    var attrsMap: [String: AnyObject?] { get set }
    var isDirty: Bool { get set }
    
    func persist() -> Void
    func sync() -> Void
    
    func setObject<T: Equatable>(object: T?, forKey key: String)
}

extension PersistedStore {
    func persist() {
        if isDirty {
            let cache = NSUserDefaults.standardUserDefaults()
            cache.setObject(attrsMap as? AnyObject, forKey: kPersistenceMapKey)
            cache.synchronize()
        }
    }
    
    func sync() {
        let cache = NSUserDefaults.standardUserDefaults()
        for (key, _) in attrsMap {
            attrsMap[key] = cache.objectForKey(key)
        }
        isDirty = false
    }
    
    private func setMapValue<T>(newValue: T, forKey key: String) {
        attrsMap[key] = newValue as? AnyObject
        isDirty = true
    }
    
    func setObject<T: Equatable>(object: T?, forKey key: String) {
        if let newValue = object {
            if let oldValue = attrsMap[key] as? T {
                if oldValue != newValue {
                    setMapValue(newValue, forKey: key)
                }
            } else {
                setMapValue(newValue, forKey: key)
            }
        }
    }
}

class AppPersistedStore: NSObject, PersistedStore {
    
    static let sharedInstance = AppPersistedStore()
    
    static let kMIXRVenueIdKey = "kMIXRVenueIdKey"
    var selectedVenueId: String? {
        set(newValue) {
            setObject(newValue, forKey: AppPersistedStore.kMIXRVenueIdKey)
        }
        get {
            return attrsMap[AppPersistedStore.kMIXRVenueIdKey] as? String
        }
    }
    
    static let kMIXRAuthToken = "kMIXRAuthToken"
    var authToken: String? {
        set(newValue) {
            setObject(newValue, forKey: AppPersistedStore.kMIXRAuthToken)
        }
        get {
            return attrsMap[AppPersistedStore.kMIXRAuthToken] as? String
        }
    }
    
    static let kMIXRUserId = "kMIXRUserId"
    var userId: String? {
        set(newValue) {
            setObject(newValue, forKey: AppPersistedStore.kMIXRUserId)
        }
        get {
            return attrsMap[AppPersistedStore.kMIXRUserId] as? String
        }
    }
    
    var attrsMap: [String: AnyObject?] = [:]
    var isDirty: Bool = false
    
    override init() {
        super.init()
        
        attrsMap = [
            AppPersistedStore.kMIXRVenueIdKey: ""
        ]
    }
    
    private func setup() {
        sync()
        
        for (key, value) in attrsMap {
            switch key {
            case AppPersistedStore.kMIXRVenueIdKey:
                selectedVenueId = value as? String
            case AppPersistedStore.kMIXRAuthToken:
                authToken = value as? String
            case AppPersistedStore.kMIXRUserId:
                userId = value as? String
            default:
                Log("Error: unsupported persistence key")
            }
        }
    }
}
