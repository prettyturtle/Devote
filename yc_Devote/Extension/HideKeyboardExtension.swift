//
//  HideKeyboardExtension.swift
//  yc_Devote
//
//  Created by yc on 2023/08/26.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
