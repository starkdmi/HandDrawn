//
//  FontSlider.swift
//  HandDrawn
//
//  Created by Dmitry Starkov on 24/10/2022.
//

import SwiftUI

/// Custom slider view
struct FontSlider: View {
    
    @Binding var progress: Float
    
    let foregroundColor: Color
    let backgroundColor: Color

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(backgroundColor)
                Rectangle()
                    .foregroundColor(foregroundColor) // .opacity(0.95)
                    .frame(width: geometry.size.width * CGFloat(self.progress / 100))
            }
            .cornerRadius(16)
            .gesture(DragGesture(minimumDistance: 0)
            .onChanged { value in
                self.progress = min(max(0, Float(value.location.x / geometry.size.width * 100)), 100)
            })
        }
    }
}
