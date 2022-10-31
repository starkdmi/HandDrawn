//
//  AVAssetTrack+Extensions.swift
//  HandDrawn
//
//  Created by Dmitry Starkov on 26/10/2022.
//

import Foundation

import Foundation
import AVKit
import Photos

extension AVAssetTrack {
    
    // When applying preferredTransform on AVMutableCompositionTrack video should be translated back
    // https://stackoverflow.com/a/64161545
    var fixedPreferredTransform: CGAffineTransform {
        var t = preferredTransform
        switch(t.a, t.b, t.c, t.d) {
        case (1, 0, 0, 1):
            t.tx = 0
            t.ty = 0
        case (1, 0, 0, -1):
            t.tx = 0
            t.ty = naturalSize.height
        case (-1, 0, 0, 1):
            t.tx = naturalSize.width
            t.ty = 0
        case (-1, 0, 0, -1):
            t.tx = naturalSize.width
            t.ty = naturalSize.height
        case (0, -1, 1, 0):
            t.tx = 0
            t.ty = naturalSize.width
        case (0, 1, -1, 0):
            t.tx = naturalSize.height
            t.ty = 0
        case (0, 1, 1, 0):
            t.tx = 0
            t.ty = 0
        case (0, -1, -1, 0):
            t.tx = naturalSize.height
            t.ty = naturalSize.width
        default:
            break
        }
        
        return t
    }
}
