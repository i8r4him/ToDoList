//
//  CreateCategoryView.swift
//  ToDoList
//
//  Created by Ibrahim Abdullah on 13.03.25.
//

import SwiftUI
import SwiftData

struct CreateCategoryView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @Query private var categories: [Category]
    @State private var title: String = ""

    var body: some View {
        List {
            Section("Category Title") {
                TextField("Enter title here", text: $title)
                Button("Add Category") {
                    addCategory()
                }
                .disabled(title.isEmpty)
            }

            Section("Categories") {
                ForEach(categories) { category in
                    Text(category.title)
                        .swipeActions {
                            Button(role: .destructive) {
                                withAnimation {
                                    context.delete(category)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                        }
                }
            }
        }
        .navigationTitle("Add Category")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button("save") {
                    dismiss()
                }
            }
        }
    }
    
    private func addCategory() {
        let newCategory = Category(title: title)
        context.insert(newCategory)
        newCategory.items = []
        title = ""
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}

#Preview {
    CreateCategoryView()
        .modelContainer(for: Category.self, inMemory: true)
}
