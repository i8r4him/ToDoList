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
            shouldCreateDefaults = false
            
            let categories = DefaultJSON.decode(from: "DefaultCategories", type: [Category].self)
            
            categories?.forEach { category in container.mainContext.insert(category) }
            
            let items = DefaultJSON.decode(from: "DefaultToDos", type: [ToDoItem].self)
            items?.forEach { item in
                container.mainContext.insert(item)
                item.category?.items?.append(item)
            }

        }
        return container
            
    }
}


extension Date {
    static func randomDateNextWeek() -> Date? {
        let calendar = Calendar.current
        let currentDate = Date.now
        
        guard let nextWeekStartDate = calendar.date(byAdding: .day, value: 7, to: currentDate) else {
            return nil
        }
        let randomTimeInterval = TimeInterval.random(in: 0..<7 * 24 * 60 * 60)
        let randomDate = nextWeekStartDate.addingTimeInterval(randomTimeInterval)
        return randomDate 
    }
}
