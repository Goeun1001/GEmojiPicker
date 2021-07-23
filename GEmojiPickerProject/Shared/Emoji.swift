//
//  Emoji.swift
//  GEmojiPickerProject
//
//  Created by GoEun Jeong on 2021/07/23.
//

import Foundation

public struct Emoji: Decodable, Hashable {
    public let string: String
    public let category: String?
    public let description: String?
    public let aliases: [String]?
    public let tags: [String]
}

private extension Emoji {
    static func parse(from fileURL: URL) -> [Emoji] {
        do {
            let data = try Data(contentsOf: fileURL, options: .mappedIfSafe)
            let decoder = JSONDecoder()
            let list = try decoder.decode([Emoji].self, from: data)
            return list
        } catch {
            return []
        }
    }
}

public final class EmojiStore {
    public let allEmojis: [Emoji]
    public let emojisByCategory: [String: [Emoji]]
    
    public static let shared = EmojiStore()
    private static let itemPerGroup: Int = 7
    
    public init() {
        guard let emojiURL = Bundle.main.url(forResource: "emoji", withExtension: "json") else {
            self.allEmojis = []
            self.emojisByCategory = [:]
            return
        }
        
        self.allEmojis = Emoji.parse(from: emojiURL)
        
        var result: [String: [Emoji]] = [:]
        for category in SectionType.defaultCategories {
            result[category.rawValue] = allEmojis.filter { $0.category == category.rawValue }
        }
        self.emojisByCategory = result
    }
    
    public func filteredEmojis(with keyword: String) -> [Emoji] {
        let lowercasedEmoji = keyword.lowercased()
        let list = allEmojis
        return list.filter { emoji in
            emoji.description?.contains(lowercasedEmoji) == true ||
                emoji.tags.first { $0.contains(lowercasedEmoji) } != nil ||
                emoji.aliases?.first { $0.contains(lowercasedEmoji) } != nil
        }
    }
}

public extension EmojiStore {
    static func systemImageName(for section: String) -> String {
        guard let sectionType = SectionType(rawValue: section) else {
            return "questionmark"
        }
        
        switch sectionType {
        case .recent: return "clock"
        case .smileys: return "smiley"
        case .people: return "person.2"
        case .animals: return "tortoise"
        case .food: return "heart"
        case .travel: return "car"
        case .activities: return "gamecontroller"
        case .objects: return "lightbulb"
        case .symbols: return "hexagon"
        case .flags: return "flag"
        }
    }
    
    static func saveRecentEmoji(_ item: Emoji) {
        var recentList: [String] = []
        let cachedList = fetchRecentList()
        if !cachedList.isEmpty {
            recentList = Array(
                cachedList
                    .filter { $0 != item.string }
                    .prefix(itemPerGroup * 3 - 1)
            )
        }
        
        recentList.insert(item.string, at: 0)
        UserDefaults.recentEmojis = recentList
        
    }
    
    static func fetchRecentList() -> [String] {
        return UserDefaults.recentEmojis
    }
}

public enum SectionType: String, CaseIterable {
    case recent = "Recent"
    case smileys = "Smileys & Emotion"
    case people = "People & Body"
    case animals = "Animals & Nature"
    case food = "Food & Drink"
    case travel = "Travel & Places"
    case activities = "Activities"
    case objects = "Objects"
    case symbols = "Symbols"
    case flags = "Flags"
    
    public static let defaultCategories: [SectionType] = SectionType.allCases
        .filter { $0 != .recent }
}
