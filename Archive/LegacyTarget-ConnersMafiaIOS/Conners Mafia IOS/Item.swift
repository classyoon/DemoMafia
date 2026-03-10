//
//  Item.swift
//  Conners Mafia IOS
//
//  Created by Conner Yoon on 2/21/26.
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
