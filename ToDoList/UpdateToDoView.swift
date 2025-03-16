//
//  UpdateToDoView.swift
//  ToDoList
//
//  Created by Ibrahim Abdullah on 13.03.25.
//

import SwiftUI
import SwiftData

struct UpdateToDoView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Bindable var item: ToDoItem
    
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
                
                Section {
                    Button(action: {
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
        }
    }
}

#Preview {
    UpdateToDoView(item: ToDoItem())
        .modelContainer(for: ToDoItem.self, inMemory: true)
}
