//
//  ActivityIndicator.swift
//  HandDrawn
//
//  Created by Dmitry Starkov on 28/10/2022.
//

import SwiftUI

/// Activity indicator ported from UIKit to support iOS 13
/// https://stackoverflow.com/a/59056440
struct ActivityIndicator: UIViewRepresentable {
    typealias UIView = UIActivityIndicatorView
    
    var isAnimating: Bool
    var configuration = { (indicator: UIView) in }

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIView { UIView() }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Self>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        configuration(uiView)
    }
}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator(isAnimating: true)
    }
}
