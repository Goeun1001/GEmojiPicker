//
//  EmojiPicker.swift
//  GEmojiPickerProject (iOS)
//
//  Created by GoEun Jeong on 2021/07/23.
//

#if os(iOS)

import SwiftUI

public struct EmojiPicker: View {
    
    @Binding var isOpen: Bool
    var selectionHandler: (Emoji)-> ()
//    @Binding var selectedEmoji: Emoji?
    
    @State var calculatedOffsetY: CGFloat = Constants.halfOffset
    @State var lastOffsetY: CGFloat = Constants.halfOffset
    @State var isDraggingDown: Bool = false
    
    @ObservedObject var sharedState = SharedState()
    
    public init(isOpen: Binding<Bool>, selectionHandler: @escaping (Emoji) -> ()) {
        self._isOpen = isOpen
        self.selectionHandler = selectionHandler
    }
    
    var offsetY: CGFloat {
        guard isOpen else { return Constants.hiddenOffset }
        let shouldToggleFromHalfState = sharedState.currentCategory != SharedState.defaultCategory &&
            lastOffsetY == Constants.halfOffset
        
        if sharedState.isSearching || shouldToggleFromHalfState {
            DispatchQueue.main.async {
                self.calculatedOffsetY = Constants.fullOffset
                self.lastOffsetY = Constants.fullOffset
            }
            
            return lastOffsetY
        }
        
        return calculatedOffsetY
    }
    
    public var body: some View {
        ZStack {
            
            MainContent()
                .offset(y: offsetY)
                .animation(.spring())
                .gesture(panelDragGesture)
                .onChange(of: sharedState.selectedEmoji) { value in
                    if let value = value {
                        selectionHandler(value)
                        EmojiStore.saveRecentEmoji(value)
                        resetViews()
                    }
                }
                .environmentObject(sharedState)
                .edgesIgnoringSafeArea(.bottom)
                .background(dimmedBackground)
            
            if isOpen, !isDraggingDown, !sharedState.isSearching, sharedState.keyword.isEmpty {
                self.sectionPicker
            }
        }
    }
    
    private var dimmedBackground: some View {
        Color.black.opacity(0.7)
            .edgesIgnoringSafeArea(.all)
            .opacity(isOpen ? 1 : 0)
            .animation(.easeIn)
            .onTapGesture {
                resetViews()
            }
    }
    
    private var displayedCategories: [String] {
        if EmojiStore.fetchRecentList().isEmpty {
            return SectionType.defaultCategories.map { $0.rawValue }
        }
        return SectionType.allCases.map { $0.rawValue }
    }
    
    private var sectionPicker: some View {
        VStack {
            Spacer()
            
            SectionIndexPicker(sections: displayedCategories)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                .environmentObject(sharedState)
        }
    }
    
    private var panelDragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                UIApplication.shared.endEditing()
                isDraggingDown = gesture.translation.height > 0
                calculatedOffsetY = max(gesture.translation.height + lastOffsetY, Constants.fullOffset)
            }
            .onEnded { gesture in
                calculatedOffsetY = max(gesture.translation.height + lastOffsetY, Constants.fullOffset)
                
                // magnet
                if isDraggingDown,
                   calculatedOffsetY >= Constants.halfOffset {
                    calculatedOffsetY = Constants.hiddenOffset
                    resetViews()
                } else {
                    calculatedOffsetY = Constants.fullOffset
                }
                
                lastOffsetY = calculatedOffsetY
                isDraggingDown = false
            }
    }
    
    private func resetViews() {
        UIApplication.shared.endEditing()
        calculatedOffsetY = Constants.halfOffset
        lastOffsetY = calculatedOffsetY
        isOpen = false
        sharedState.resetState()
    }
}

struct EmojiPicker_Previews: PreviewProvider {
    static var previews: some View {
        EmojiPicker(isOpen: .constant(true), selectionHandler: { _ in })
    }
}

#endif
