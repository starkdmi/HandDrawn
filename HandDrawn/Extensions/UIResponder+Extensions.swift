//
//  UIResponder+Extensions.swift
//  HandDrawn
//
//  Created by Dmitry Starkov on 21/10/2022.
//

import UIKit

extension UIResponder {
    /// Access parent controller
    public var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
