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
        EmojiPicker(isOpen: .constant(true), selectionHandler: { _ in })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
