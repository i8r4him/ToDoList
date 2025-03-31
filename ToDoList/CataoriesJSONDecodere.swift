//
//  CataoriesJSODecodere.swift
//  ToDoList
//
//  Created by Ibrahim Abdullah on 31.03.25.
//

import Foundation

struct CategoryResponse: Decodable {
    let title: String
}

struct CategoryJSONDecoder {
    static func decode(from fileName: String) -> [CategoryResponse] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let categories = try? JSONDecoder().decode([CategoryResponse].self, from: data) else {
            return []
        }
        return categories
    }
}
