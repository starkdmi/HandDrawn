//
//  Colors+Extensions.swift
//  HandDrawn
//
//  Created by Dmitry Starkov on 31/10/2022.
//

import SwiftUI

extension Color {
    /// Main background color
    static let dark = Color(red: 56/255, green: 56/255, blue: 56/255)
    
    /// Main foreground color
    static let light = Color.white
    
    /// Color used for views background which is differ from main background
    static let darkHighlight = Color(red: 64/255, green: 64/255, blue: 64/255)
    
    static let permissionsBackground = Color(red: 29/255, green: 28/255, blue: 30/255)
}

extension UIColor {
    /// Main background color
    static let dark = UIColor(red: 56/255, green: 56/255, blue: 56/255, alpha: 1.0)
    
    /// Main foreground color
    static let light = UIColor.white
}
