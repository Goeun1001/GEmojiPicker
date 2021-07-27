//
//  ContentView.swift
//  Shared
//
//  Created by GoEun Jeong on 2021/07/26.
//

import SwiftUI
import GEmojiPicker

struct ContentView: View {
    var body: some View {
        let shared = SharedState()
        EmojiPicker(emojiStore: EmojiStore(), selectionHandler: { _ in })
            .environmentObject(shared)
//        EmojiPicker(isOpen: .constant(true), selectionHandler: { _ in })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
