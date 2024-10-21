//
//  DefaultManager.swift
//  AlomafireNetwork
//
//  Created by Mert Saygılı on 21.10.2024.
//

import Foundation

enum UserDefaultKeys: String {
    case token
    case language
}

// User Default Protocol
protocol UserDefaultsProtocol {
    static func setValue<T>(value: T, key: UserDefaultKeys)
    static func getValue<T>(key: UserDefaultKeys) -> T?
    static func removeValue(key: UserDefaultKeys)
}

struct DefaultsManager: UserDefaultsProtocol {
    // instance of UserDefaults
    private static let defaults = UserDefaults.standard

    static func setValue<T>(value: T, key: UserDefaultKeys) {
        defaults.set(value, forKey: key.rawValue)
    }

    static func getValue<T>(key: UserDefaultKeys) -> T? {
        return defaults.object(forKey: key.rawValue) as? T
    }

    static func removeValue(key: UserDefaultKeys) {
        defaults.removeObject(forKey: key.rawValue)
    }
}
