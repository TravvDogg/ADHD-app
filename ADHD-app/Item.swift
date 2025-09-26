//
//  Item.swift
//  ADHD-app
//
//  Created by Travis Lizio on 26/9/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
