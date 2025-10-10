import Foundation
import UIKit
import SwiftData

@Model
final class Capture {
    var title: String
    var mission: String?
    var note: String?
    var emoji: String?
    var steps: Int?
    var imageData: Data?
    var createdAt: Date

    init(
        title: String,
        mission: String? = nil,
        note: String? = nil,
        emoji: String? = nil,
        steps: Int? = nil,
        imageData: Data? = nil,
        createdAt: Date = Date()
    ) {
        self.title = title
        self.mission = mission
        self.note = note
        self.emoji = emoji
        self.steps = steps
        self.imageData = imageData
        self.createdAt = createdAt
    }
}

extension Capture {
    var displayTitle: String { title.isEmpty ? "Untitled Capture" : title }
    var displayNote: String { (note?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ? note! : "No note yet.") }
    var displayEmoji: String { emoji ?? "🙂" }
    var displayMission: String { (mission?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ? mission! : (title.isEmpty ? "Mission" : title)) }

    var uiImage: UIImage? {
        guard let data = imageData else { return nil }
        return UIImage(data: data)
    }
}
