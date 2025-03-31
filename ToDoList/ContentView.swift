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
    
    enum SortType: String, CaseIterable, Identifiable {
        case title, date, category
        var id: String { rawValue }
    }

    @State private var sortType: SortType = .date
    @State private var sortAscending: Bool = true
    
    @Query(filter: #Predicate { (item: ToDoItem) in
        item.isCompleted == false
    }) private var unsortedItems: [ToDoItem]
    
    var filteredItems: [ToDoItem] {
    let filtered = searchQuery.isEmpty ? unsortedItems : unsortedItems.filter {
        $0.title.localizedCaseInsensitiveContains(searchQuery) ||
        $0.category?.title.localizedCaseInsensitiveContains(searchQuery) == true
    }
    return sortedItems(from: filtered)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if unsortedItems.isEmpty && searchQuery.isEmpty {
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
            .animation(.easeIn, value: filteredItems)
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
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        showCreateCategory = true
                    }) {
                        Label("Categories", systemImage: "folder.badge.plus")
                    }

                    Menu {
                        Picker("Sort By", selection: $sortType) {
                            Label("Title", systemImage: "textformat").tag(SortType.title)
                            Label("Date", systemImage: "calendar").tag(SortType.date)
                            Label("Category", systemImage: "folder").tag(SortType.category)
                        }
                        Divider()
                        Button(action: {
                            sortAscending.toggle()
                        }) {
                            Label("Order: \(sortAscending ? "Ascending" : "Descending")", systemImage: sortAscending ? "arrow.down" : "arrow.up")
                        }
                    } label: {
                        Label("Sort", systemImage: "ellipsis.circle")
                    }
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

private extension ContentView {
    func sortedItems(from list: [ToDoItem]) -> [ToDoItem] {
        switch sortType {
        case .title:
            return list.sorted {
                sortAscending ? $0.title < $1.title : $0.title > $1.title
            }
        case .date:
            return list.sorted {
                sortAscending ? $0.timestamp < $1.timestamp : $0.timestamp > $1.timestamp
            }
        case .category:
            return list.sorted {
                let lhs = $0.category?.title ?? ""
                let rhs = $1.category?.title ?? ""
                return sortAscending ? lhs < rhs : lhs > rhs
            }
        }
    }

    var items: [ToDoItem] {
        sortedItems(from: unsortedItems)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ToDoItem.self, inMemory: true)
}
