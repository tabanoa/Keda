//
//  Manager.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import Foundation

class Manager {
    
    static let sharedInstance = Manager()
    private let defaults = UserDefaults.standard
    
    private let firstTimeKey = "FirstTimeKey"
    private let firstLoginKey = "FirstLoginKey"
    private let resForFirstTimeNotif = "RegistrationForFirstTimeNotificationKey"
    
    func setFirstTime(_ first: Bool) {
        defaults.set(first, forKey: firstTimeKey)
    }
    
    func getFirstTime() -> Bool {
        return defaults.bool(forKey: firstTimeKey)
    }
    
    func setFirstLogin(_ first: Bool) {
        defaults.set(first, forKey: firstLoginKey)
    }
    
    func getFirstLogin() -> Bool {
        return defaults.bool(forKey: firstLoginKey)
    }
    
    func setFirstTimeNotif(_ first: Bool) {
        defaults.set(first, forKey: resForFirstTimeNotif)
    }
    
    func getFirstTimeNotif() -> Bool {
        return defaults.bool(forKey: resForFirstTimeNotif)
    }
    
    
}
