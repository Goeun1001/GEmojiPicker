//
//  Keyboard.swift
//  GEmojiPickerProject (iOS)
//
//  Created by GoEun Jeong on 2021/07/23.
//

#if os(iOS)

import UIKit

// MARK: Dismiss keyboard
extension UIApplication {
    func endEditing() {
        windows.forEach { $0.endEditing(false) }
    }
}

#endif


