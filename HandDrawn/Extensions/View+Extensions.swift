//
//  View+Extensions.swift
//  HandDrawn
//
//  Created by Dmitry Starkov on 21/10/2022.
//

import SwiftUI
import Combine

extension UIView {
    func copyView<T: UIView>() -> T {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }
}

extension CALayer {
    var copied: CALayer {
        NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! CALayer
    }
}
