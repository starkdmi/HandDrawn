//
//  View+Extensions.swift
//  HandDrawn
//
//  Created by Dmitry Starkov on 21/10/2022.
//

import SwiftUI
import Combine

extension View {
    @ViewBuilder func stateChange<T: Equatable>(value: T, onChange: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            self.onChange(of: value, perform: onChange)
        } else {
            self.onReceive(Just(value), perform: onChange)
        }
    }
    
    @ViewBuilder func ignoreKeyboard() -> some View {
        if #available(iOS 14.0, *) {
            self.ignoresSafeArea(.keyboard)
        } else {
            self
        }
    }
}

extension View where Self == ActivityIndicator {
    func configure(_ configuration: @escaping (Self.UIView)->Void) -> Self {
        Self.init(isAnimating: self.isAnimating, configuration: configuration)
    }
}

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
