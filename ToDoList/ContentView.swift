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
    @State private var editItem: ToDoItem?
    @State private var showCreateCategory = false
    @State private var searchQuery = ""
    
    @Query(filter: #Predicate { (item: ToDoItem) in
        item.isCompleted == false
    }, sort: \.timestamp) private var items: [ToDoItem]
    
    var filteredItems: [ToDoItem] {
        if searchQuery.isEmpty {
            return items
        }
        return items.filter {
            $0.title.localizedCaseInsensitiveContains(searchQuery) ||
            $0.category?.title.localizedCaseInsensitiveContains(searchQuery) == true
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if items.isEmpty && searchQuery.isEmpty {
                    ContentUnavailableView("No Task Found", systemImage: "tray")
                } else {
                    List {
                        ForEach(filteredItems) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    if item.isCritical {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundColor(.red)
                                            .font(.title2)
                                            .bold()
                                    }
                                    
                                    Text(item.title)
                                        .font(.title)
                                        .bold()
                                    
                                    Text("\(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .shortened))")
                                        .font(.callout)
                                    
                                    if let category = item.category {
                                        Text(category.title)
                                            .foregroundColor(.blue)
                                            .padding(.horizontal)
                                            .padding(.vertical, 4)
                                            .background(
                                                Color.blue.opacity(0.1),
                                                in: RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            )
                                    }
                                }
                                
                                Spacer()
                                
                                Button {
                                    withAnimation {
                                        item.isCompleted.toggle()
                                    }
                                } label: {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(item.isCompleted ? .green : .gray)
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
                                    Label("Delete", systemImage: "trash.fill")
                                }
                                
                                Button {
                                    editItem = item
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.orange)
                            }
                        }
                    }
                }
            }
            .navigationTitle("To Do List")
            .safeAreaInset(edge: .bottom, alignment: .leading) {
                Button(action: {
                    showCreate.toggle()
                }) {
                    Label("New ToDo", systemImage: "plus")
                        .padding()
                        .background(Color.gray.opacity(0.1), in: Capsule())
                }
                .padding()
            }
            .toolbar {
                Button(action: {
                    showCreateCategory = true
                }) {
                    Label("Categories", systemImage: "folder.badge.plus")
                }
            }
            .searchable(text: $searchQuery, prompt: "Search for a task or a category")
            .overlay {
                if !searchQuery.isEmpty && filteredItems.isEmpty {
                    ContentUnavailableView.search
                }
            }
            .sheet(isPresented: $showCreateCategory) {
                NavigationStack {
                    CreateCategoryView()
                }
            }
            .sheet(item: $editItem) {
                editItem = nil
            } content: { item in
                UpdateToDoView(item: item)
            }
            .sheet(isPresented: $showCreate) {
                NavigationStack {
                    CreateTodoView()
                        .navigationTitle("Create ToDo")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ToDoItem.self, inMemory: true)
}
