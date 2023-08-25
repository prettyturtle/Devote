//
//  ListRowItemView.swift
//  yc_Devote
//
//  Created by yc on 2023/08/26.
//

import SwiftUI

struct ListRowItemView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var item: Item
    
    var body: some View {
        Toggle(isOn: $item.completion) {
            Text(item.task ?? "")
                .font(.system(.title2, design: .rounded))
                .fontWeight(.heavy)
                .foregroundColor(item.completion ? .pink : .primary)
                .padding(.vertical, 12)
                .animation(.default, value: item.completion)
        }
        .toggleStyle(CheckboxStyle())
        .onReceive(item.objectWillChange) { _ in
            print("12312321321")
            if self.viewContext.hasChanges {
                print("85u858475983")
                try? self.viewContext.save()
            }
        }
    }
}
