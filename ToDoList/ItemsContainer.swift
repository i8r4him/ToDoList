//
//  ItemsContainer.swift
//  ToDoList
//
//  Created by Ibrahim Abdullah on 31.03.25.
//

import Foundation
import SwiftData

actor ItemsContainer {
    
    @MainActor
    static func create(shouldCreateDefaults: inout Bool) -> ModelContainer {
        let schema = Schema([ToDoItem.self])
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: configuration)
        if shouldCreateDefaults {
            
            let categories = CategoryJSONDecoder.decode(from: "CategoriesDefaults")
            if categories.isEmpty == false {
                categories.forEach { item in
                    let category = Category(title: item.title)
                    container.mainContext.insert(category)
                }
            }
            shouldCreateDefaults = false
        }
        return container
            
    }
}
