//
//  CreateTodoView.swift
//  ToDoList
//
//  Created by Ibrahim Abdullah on 12.03.25.
//

import SwiftUI

struct CreateTodoView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @State private var item: ToDoItem = ToDoItem()
    
    var body: some View {
        List {
            Section(header: Text("Task Details")) {
                TextField("Enter task name", text: $item.title)
                DatePicker("Select Date", selection: $item.timestamp)

            }
            
            Section(header: Text("Date & Priority")) {
                Toggle("Mark as Important", isOn: $item.isCritical)
                
            }
            
            Button("Create Task") {
                withAnimation {
                    context.insert(item)
                }
                dismiss()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(role: .destructive) {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
            }
        }
    }
}

#Preview {
    CreateTodoView()
        .modelContainer(for: ToDoItem.self, inMemory: true)
}
