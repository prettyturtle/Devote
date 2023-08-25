//
//  ContentView.swift
//  yc_Devote
//
//  Created by yc on 2023/08/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: - PROPERTIES
    
    @State var task: String = ""
    private var isButtonDisabled: Bool { task.isEmpty }
    
    // FETCHING DATA
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default
    )
    private var items: FetchedResults<Item>
    
    // MARK: - FUNCTIONS
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false
            newItem.id = UUID()
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            task = ""
            hideKeyboard()
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    VStack(spacing: 16) {
                        TextField(text: $task) {
                            Text("New Task")
                        }
                        .padding()
                        .background(
                            Color(UIColor.systemGray6)
                        )
                        .cornerRadius(10)
                        
                        Button {
                            addItem()
                        } label: {
                            Spacer()
                            Text("SAVE")
                            Spacer()
                        }
                        .disabled(isButtonDisabled)
                        .padding()
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(isButtonDisabled ? .gray : .pink)
                        .cornerRadius(10)
                    } //: VSTACK
                    .padding()
                    
                    List {
                        ForEach(items) { item in
                            NavigationLink {
                                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(item.task ?? "")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    
                                    Text(item.timestamp!, formatter: itemFormatter)
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                } //: LIST ITEM
                            }
                        }
                        .onDelete(perform: deleteItems)
                        
                        if items.isEmpty {
                            Spacer()
                                .listRowBackground(Color.clear)
                        }
                    } //: LIST
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    .background(.clear)
                    .shadow(color: .black.opacity(0.3), radius: 12)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)
                } //: VSTACK
            } //: ZSTACK
            .navigationTitle("Daily Tasks")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            } //: TOOLBAR
            .background(
                BackgroundImageView()
            )
            .background(
                backgroundGradient.ignoresSafeArea(.all)
            )
        } //: NAVIGATION
        .navigationViewStyle(.stack)
    }
}

// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
