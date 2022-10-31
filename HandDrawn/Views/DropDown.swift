//
//  DropDown.swift
//  HandDrawn
//
//  Created by Dmitry Starkov on 21/10/2022.
//

import SwiftUI

struct DropDownItem: Hashable {
    var action: () -> Void
    var systemName: String

    static func == (lhs: DropDownItem, rhs: DropDownItem) -> Bool {
        return lhs.systemName == rhs.systemName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(systemName)
    }
}

/// Custom drop down view used for shapes button
struct DropDown: View {
    @State private var expanded = false
    
    var items: [DropDownItem]
    
    var body: some View {
        VStack {
            if (expanded) {
                VStack(spacing: 6) {
                    ForEach(items, id: \.self) { item in
                        CircleIcon(systemName: item.systemName)
                            .onTapGesture {
                                item.action()
                                expanded.toggle()
                            }
                    }
                }
            }
            
            Spacer().frame(height: 12)
            
            CircleIcon(systemName: expanded ? "chevron.down" : "square.on.circle") // xmark
                .onTapGesture {
                    expanded.toggle()
                }
            
            Spacer().frame(height: 12)
            
            if (expanded) {
                VStack(spacing: 6) {
                    ForEach(items, id: \.self) { _ in
                        Spacer().frame(height: 36)
                    }
                }
            }
        }.animation(.spring())
    }
}
