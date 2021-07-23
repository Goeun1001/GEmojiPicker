//
//  UserDefaults.swift
//  GEmojiPickerProject
//
//  Created by GoEun Jeong on 2021/07/23.
//

import Foundation

@propertyWrapper
public struct UserDefaultWrapper<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard

    public var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}

extension UserDefaults {
    static let happyUserDefaults = UserDefaults(suiteName: "group.com.jeonggo.EmojiPickerDemo")!

    @UserDefaultWrapper(key: "recent_emojis", defaultValue: [], container: .happyUserDefaults)
    static var recentEmojis: [String]
}
