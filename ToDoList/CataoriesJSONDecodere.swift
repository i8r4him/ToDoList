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

struct DefaultJSON {
    static func decode<T: Codable>(from fileName: String, type: T.Type) -> T? {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
                let data = try? Data(contentsOf: url),
              let result = try? JSONDecoder().decode(T.self, from: data) else {
            return nil
        }
        return result
    }
}
