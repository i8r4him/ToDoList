//
//  Category.swift
//  ToDoList
//
//  Created by Ibrahim Abdullah on 13.03.25.
//

import Foundation
import SwiftData

@Model
class Category: Codable {
    
    @Attribute(.unique)
    var title: String
    
    var items: [ToDoItem]?
    
    init(title: String = "") {
        self.title = title
    }
    
    enum CodingKeys: String, CodingKey {
        case title
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
    }
}

extension Category {
    static var defaults: [Category] {
        [
            .init(title: "🙇🏾‍♂️ Study"),
            .init(title: "🤝 Routine"),
            .init(title: "🏠 Family")
        ]
    }
}
