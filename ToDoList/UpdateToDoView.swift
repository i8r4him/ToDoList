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
        List {
            Section(header: Text("Task Details")) {
                TextField("Enter task name", text: $item.title)
                DatePicker("Select Date", selection: $item.timestamp)

            }
            
            Section(header: Text("Date & Priority")) {
                Toggle("Mark as Important", isOn: $item.isCritical)
                
            }
            
            Button("Update Task") {
                dismiss()
            }
        }
        .navigationTitle("Update ToDo")
    }
}

#Preview {
    UpdateToDoView(item: ToDoItem())
        .modelContainer(for: ToDoItem.self, inMemory: true)
}
