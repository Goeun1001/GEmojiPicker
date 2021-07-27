//
//  SearchBar.swift
//  GEmojiPickerProject (iOS)
//
//  Created by GoEun Jeong on 2021/07/23.
//

#if os(OSX)

import SwiftUI

struct SearchBar: View {
    @EnvironmentObject var sharedState: SharedState
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .padding(.leading, 8)
            TextField("Search emojis",
                      text: $sharedState.keyword)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .frame(height: 44)
        .padding(.horizontal, 8)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar()
            .environmentObject(SharedState())
    }
}

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { super.focusRingType = .none }
    }
}

#endif
