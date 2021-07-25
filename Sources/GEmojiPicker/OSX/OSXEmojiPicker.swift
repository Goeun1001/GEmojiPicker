//
//  EmojiPicker.swift
//  GEmojiPickerProject (iOS)
//
//  Created by GoEun Jeong on 2021/07/23.
//

#if os(OSX)

import SwiftUI

struct EmojiPicker: View {
    @EnvironmentObject var sharedState: SharedState
    
    var emojiStore: EmojiStore
    var selectionHandler: (Emoji)->Void
    
    @State private var categoryUpdatedByOffset = false
    
    @State private var currentKaomojiTag: String?
    
    init(emojiStore: EmojiStore, selectionHandler: @escaping (Emoji)->Void) {
        self.emojiStore = emojiStore
        self.selectionHandler = selectionHandler
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 2) {
                SearchBar()
                    .environmentObject(sharedState)
            }
            .font(.title3)
            .foregroundColor(Color(NSColor.textColor))
            .padding(.trailing, 8)
            
            ZStack {
                
                self.emojiSections
                
                
                if sharedState.isSearching || !sharedState.keyword.isEmpty {
                    self.emojiResults
                }
            }
            
            if !sharedState.isSearching, sharedState.keyword.isEmpty {
                self.sectionPicker
            }
        }
        .background(Color.background)
        .cornerRadius(8)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private var recentEmojiSection: some View {
        EmojiSection(
            title: SectionType.recent.rawValue,
            items: EmojiStore.fetchRecentList(),
            contentKeyPath: \.self) { emoji in
            guard let item = emojiStore.allEmojis.first(where: { $0.string == emoji }) else { return }
            self.selectionHandler(item)
        }
    }
    
    private var emojiSections: some View {
        ScrollViewReader { proxy in
            GeometryReader { geometry in
                List {
                    Group {
                        if !EmojiStore.fetchRecentList().isEmpty {
                            let category = SectionType.recent.rawValue
                            recentEmojiSection
                                .id(category)
                                .observeOffset(
                                    for: category,
                                    geometryProxy: geometry,
                                    sharedState: sharedState,
                                    updateHandler: {
                                        categoryUpdatedByOffset = true
                                    }
                                )
                        }
                        
                        ForEach(SectionType.defaultCategories.map { $0.rawValue }, id: \.self) { category in
                            EmojiSection(
                                title: category,
                                items: emojiStore.emojisByCategory[category]!,
                                contentKeyPath: \.string) {
                                self.selectionHandler($0)
                            }
                            .observeOffset(
                                for: category,
                                geometryProxy: geometry,
                                sharedState: sharedState,
                                updateHandler: {
                                    categoryUpdatedByOffset = true
                                }
                            )
                        }
                    }
                    .onChange(of: sharedState.currentCategory) { target in
                        guard !categoryUpdatedByOffset else {
                            return
                        }
                        proxy.scrollTo(target, anchor: .top)
                    }
                }
            }
        }
    }
    
    private var emojiResults: some View {
        Group {
            if sharedState.keyword.isEmpty {
                EmptyView()
            } else if emojiStore.filteredEmojis(with: sharedState.keyword).isEmpty {
                
                VStack {
                    Text("No emoji found for \"\(sharedState.keyword)\"")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.top, 32)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.background)
                
            } else {
                List {
                    EmojiSection(
                        title: "Search Results",
                        items: emojiStore.filteredEmojis(with: sharedState.keyword),
                        contentKeyPath: \.string) {
                        self.selectionHandler($0)
                    }
                }
            }
        }
    }
    
    private var sectionPicker: some View {
        SectionIndexPicker(sections: displayedCategories) { categoryUpdatedByOffset = false }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .environmentObject(sharedState)
    }
    
    private var displayedCategories: [String] {
        if EmojiStore.fetchRecentList().isEmpty {
            return SectionType.defaultCategories.map { $0.rawValue }
        }
        return SectionType.allCases.map { $0.rawValue }
    }
}

struct EmojiPicker_Previews: PreviewProvider {
    static var previews: some View {
        EmojiPicker(emojiStore: EmojiStore.shared,
                    selectionHandler: { _ in })
            .environmentObject(SharedState())
    }
}

#endif
