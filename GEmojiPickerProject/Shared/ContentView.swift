//
//  ContentView.swift
//  Shared
//
//  Created by GoEun Jeong on 2021/07/23.
//

import SwiftUI

struct ContentView: View {
    @State var isOpen = true
    var body: some View {
        #if os(iOS) {
            EmojiPicker(isOpen: $isOpen, completionHandler: {
                print($0.string)
            })
        } #elseif {
            EmojiPicker(emojiStore: EmojiStore(), selectionHandler: { print($0.string
            ) })
            .environmentObject(SharedState())
            }
        #endif
        Text("")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
