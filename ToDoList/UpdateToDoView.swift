//
//  UpdateToDoView.swift
//  ToDoList
//
//  Created by Ibrahim Abdullah on 13.03.25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct UpdateToDoView: View {
    
    @State private var selectedCategory: Category?
    @State private var selectedphoto: PhotosPickerItem?
    
    @Environment(\.dismiss) var dismiss
    
    @Bindable var item: ToDoItem
    
    @Query private var categories: [Category]
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Task Details")) {
                    TextField("Enter task name", text: $item.title)
                    
                    DatePicker("Select Date", selection: $item.timestamp, displayedComponents: .date)
                        .datePickerStyle(.compact)
                }
                
                Section(header: Text("Priority & Status")) {
                    Toggle("Mark as Important", isOn: $item.isCritical)
                        .tint(.orange)
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
                
                Section {
                    Button(action: {
                        item.category = selectedCategory
                        dismiss()
                    }) {
                        Text("Update Task")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .navigationTitle("Update ToDo")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                selectedCategory = item.category
            })
            .task(id: selectedphoto) {
                if let data = try? await selectedphoto?.loadTransferable(type: Data.self) {
                    item.image = data
                }
            }
        }
    }
}

#Preview {
    UpdateToDoView(item: ToDoItem())
        .modelContainer(for: ToDoItem.self, inMemory: true)
}
