//
//  NewTaskItemView.swift
//  yc_Devote
//
//  Created by yc on 2023/08/26.
//

import SwiftUI

struct NewTaskItemView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State private var task: String = ""
    @Binding var isShowing: Bool
    
    private var isButtonDisabled: Bool { task.isEmpty }
    
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
            
            withAnimation(.easeOut) {
                isShowing = false
            }
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                TextField(text: $task) {
                    Text("New Task")
                }
                .foregroundColor(.pink)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .padding()
                .background(
                    isDarkMode ? Color(UIColor.tertiarySystemBackground) : Color(UIColor.secondarySystemBackground)
                    
                )
                .cornerRadius(10)
                
                Button {
                    addItem()
                } label: {
                    Spacer()
                    Text("SAVE")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Spacer()
                }
                .disabled(isButtonDisabled)
                .padding()
                .foregroundColor(.white)
                .background(isButtonDisabled ? .blue : .pink)
                .cornerRadius(10)
            } //: VSTACK
            .padding(.horizontal)
            .padding(.vertical, 20)
            .background(
                isDarkMode ? Color(UIColor.secondarySystemBackground) : .white
            )
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.65), radius: 24)
            .frame(maxWidth: 640)
        } //: VSTACK
        .padding()
    }
}

struct NewTaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskItemView(isShowing: .constant(true))
            .background(Color.gray.ignoresSafeArea(.all))
    }
}
