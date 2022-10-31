//
//  UIImageView+Extensions.swift
//  HandDrawn
//
//  Created by Dmitry Starkov on 31/10/2022.
//

import UIKit

// https://stackoverflow.com/a/43861643
extension UIImageView {

    /// Find the size of the image, once the parent imageView has been given a contentMode of .scaleAspectFit
    /// Querying the image.size returns the non-scaled size. This helper property is needed for accurate results.
    var aspectFitSize: CGSize {
        guard let image = image else { return CGSize.zero }

        var aspectFitSize = CGSize(width: frame.size.width, height: frame.size.height)
        let newWidth: CGFloat = frame.size.width / image.size.width
        let newHeight: CGFloat = frame.size.height / image.size.height

        if newHeight < newWidth {
            aspectFitSize.width = newHeight * image.size.width
        } else if newWidth < newHeight {
            aspectFitSize.height = newWidth * image.size.height
        }

        return aspectFitSize
    }

    /// Find the size of the image, once the parent imageView has been given a contentMode of .scaleAspectFill
    /// Querying the image.size returns the non-scaled, vastly too large size. This helper property is needed for accurate results.
    var aspectFillSize: CGSize {
        guard let image = image else { return CGSize.zero }

        var aspectFillSize = CGSize(width: frame.size.width, height: frame.size.height)
        let newWidth: CGFloat = frame.size.width / image.size.width
        let newHeight: CGFloat = frame.size.height / image.size.height

        if newHeight > newWidth {
            aspectFillSize.width = newHeight * image.size.width
        } else if newWidth > newHeight {
            aspectFillSize.height = newWidth * image.size.height
        }

        return aspectFillSize
    }
}
