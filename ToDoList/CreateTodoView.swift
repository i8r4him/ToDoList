//
//  CreateTodoView.swift
//  ToDoList
//
//  Created by Ibrahim Abdullah on 12.03.25.
//

import SwiftUI
import SwiftData

struct CreateTodoView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @Query private var categories: [Category]
    
    @State private var item: ToDoItem = ToDoItem()
    @State private var selectedCategory: Category?
    
    var body: some View {
        List {
            Section(header: Text("Task Details")) {
                TextField("Enter task name", text: $item.title)
                DatePicker("Select Date", selection: $item.timestamp)

            }
            
            Section(header: Text("Date & Priority")) {
                Toggle("Mark as Important", isOn: $item.isCritical)
                
            }
            
            Section(header: Text("Category")) {
                Picker("Select Category", selection: $selectedCategory) {
                    ForEach(categories) { category in
                        Text(category.title)
                            .tag(category as Category?)
                    }
                    Text("None")
                        .tag(nil as Category?)
                }
            }
            
            Button("Create Task") {
                save()
                dismiss()
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button("Save") {
                    save()
                    dismiss()
                }
                .disabled(item.title.isEmpty)
            }
        }
    }
}

private extension CreateTodoView {
    func save() {
        context.insert(item)
        item.category = selectedCategory
        selectedCategory?.items?.append(item)
    }
}

#Preview {
    CreateTodoView()
        .modelContainer(for: ToDoItem.self, inMemory: true)
}
