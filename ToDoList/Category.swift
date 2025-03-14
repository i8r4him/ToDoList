//
//  Category.swift
//  ToDoList
//
//  Created by Ibrahim Abdullah on 13.03.25.
//

import Foundation
import SwiftData

@Model
class Category {
    
    @Attribute(.unique)
    var title: String
    
    var items: [ToDoItem]?
    
    init(title: String = "") {
        self.title = title
    }
}
