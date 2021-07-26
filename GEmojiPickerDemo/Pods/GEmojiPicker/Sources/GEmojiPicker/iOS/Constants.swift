//
//  Constants.swift
//  GEmojiPickerProject (iOS)
//
//  Created by GoEun Jeong on 2021/07/23.
//

#if os(iOS)

import UIKit

enum Constants {
    static let screenHeight = UIScreen.main.bounds.size.height
    static let maxHeight: CGFloat = screenHeight - 24
    static let midHeight: CGFloat = UIScreen.main.bounds.size.height / 2
    static let minHeight: CGFloat = 0
    
    static let halfOffset: CGFloat = maxHeight - midHeight
    static let fullOffset: CGFloat = 24
    static let hiddenOffset: CGFloat = screenHeight
}

#endif
