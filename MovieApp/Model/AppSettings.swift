//
//  AppSettings.swift
//  MovieApp
//
//  Created by NikitaPrakash Patil on 3/24/19.
//  Copyright © 2019 NikitaPrakash Patil. All rights reserved.
//

import Foundation

final class AppSettings {
    
    private enum SettingKey: String {
        case displayName
    }
    
    static var displayName: String! {
        get {
            return UserDefaults.standard.string(forKey: SettingKey.displayName.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            let key = SettingKey.displayName.rawValue
            
            if let name = newValue {
                defaults.set(name, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
}

