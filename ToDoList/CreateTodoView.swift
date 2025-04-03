//
//  CreateTodoView.swift
//  ToDoList
//
//  Created by Ibrahim Abdullah on 12.03.25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct CreateTodoView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @Query private var categories: [Category]
    
    @State private var item: ToDoItem = ToDoItem()
    @State private var selectedCategory: Category?
    
    @State private var selectedphoto: PhotosPickerItem?
    
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
                if (categories.isEmpty) {
                    ContentUnavailableView("No Category Found", systemImage: "archivebox")
                } else {
                    Picker("Select Category", selection: $selectedCategory) {
                        ForEach(categories) { category in
                            Text(category.title)
                                .tag(category as Category?)
                        }
                        Text("None")
                            .tag(nil as Category?)
                    }
                }
            }
            
            Section("Select an image") {
                
                if let imageData = item.image,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                }
                
                PhotosPicker(selection: $selectedphoto,
                                matching: .images,
                             photoLibrary: .shared()) {
                    Label("Select a photo", systemImage: "photo")
                }
                
                if selectedphoto != nil {
                    Button(role: .destructive) {
                        selectedphoto = nil
                        item.image = nil
                    } label: {
                        Label("Remove Photo", systemImage: "trash")
                    }
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
        .task(id: selectedphoto) {
            if let data = try? await selectedphoto?.loadTransferable(type: Data.self) {
                item.image = data
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
