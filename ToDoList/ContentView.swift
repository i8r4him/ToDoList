//
//  ContentView.swift
//  ToDoList
//
//  Created by Ibrahim Abdullah on 12.03.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) var context
    
    @State private var showCreate = false
    @State private var EditItem: ToDoItem?
    @State private var searchQery = ""
    
    @Query(filter: #Predicate { (item: ToDoItem) in
        item.isCompleted == false
    }, sort: \.timestamp) private var items: [ToDoItem]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            if item.isCritical {
                                Image(systemName: "exclamationmark.3")
                                    .symbolVariant(.fill)
                                    .foregroundColor(.red)
                                    .font(.title2)
                                    .bold()
                            }
                            
                            Text(item.title)
                                .font(.title)
                                .bold()
                            
                            Text("\(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .shortened))")
                                .font(.callout)
                                
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                item.isCompleted.toggle()
                            }
                        } label: {
                            Image(systemName: "checkmark")
                                .symbolVariant(.circle.fill)
                                .foregroundStyle(item.isCompleted ? .green : .gray)
                                .font(.title)
                            
                        }
                        .buttonStyle(.plain)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            withAnimation {
                                context.delete(item)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                                .symbolVariant(.fill)
                        }
                        
                        Button {
                            EditItem = item
                        } label: {
                            Label("Edit", systemImage: "Pencil")
                        }
                        .tint(.orange)
                    }
                }
            }
            .navigationTitle("To Do List")
            .toolbar {
                Button(action: {
                    showCreate.toggle()
                }) {
                    Label("Create", systemImage: "plus")
                }
            }
            .searchable(text: $searchQery, prompt: "Search for a task or a category")
            .overlay {
                // TODO: Add search functionality
            }
            .sheet(item: $EditItem) {
                EditItem = nil
            } content: { item in
                UpdateToDoView(item: item)
            }
            .sheet(isPresented: $showCreate, content: {
                NavigationStack {
                    CreateTodoView()
                        .navigationTitle("Create ToDo")
                        .navigationBarTitleDisplayMode(.inline)
                }
            })
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ToDoItem.self, inMemory: true)
}
