//
//  PKDrawing+Extensions.swift
//  HandDrawn
//
//  Created by Dmitry Starkov on 20/10/2022.
//

import PencilKit

enum DrawingShape: String {
    /// ML keys used to init
    case ellipsis = "circle", rectangle, triangle, star
}

extension PKDrawing {
    
    /// Create PKDrawing from predefined shapes
    /// `thikness` will be overriden from PKInkingTool if provided
    init(with shape: DrawingShape, in bounds: CGRect, tool: PKInkingTool?, opacity: CGFloat = 1.0, thikness: CGFloat = 3.0) {
        // load thikness from PKInkingTool if available
        var thikness = thikness
        if let tool = tool {
            thikness = max(3.0, tool.width)
        }
        
        switch (shape) {
        case .ellipsis:
            if #available(iOS 14.0, *) {
                let ink: PKInk = tool?.ink ?? PKInk(.pen, color: UIColor.systemRed)

                let diameter: Double
                var scaleX = 1.0, scaleY = 1.0
                if (bounds.width > bounds.height) {
                    diameter = bounds.height
                    // scale horizontally
                    scaleX = bounds.width / bounds.height
                } else {
                    diameter = bounds.width
                    // scale vertically
                    scaleY = bounds.height / bounds.width
                }
                                
                let radius = diameter / 2.0
                let origin = CGPoint(
                    x: bounds.origin.x + bounds.width / 2.0,
                    y: bounds.origin.y + bounds.height / 2.0
                )
                
                // draw circle inside the bounds
                var controlPoints: [PKStrokePoint] = []
                controlPoints.reserveCapacity(360)
                                
                var angle = 0.0
                for i in 0...360 {
                    angle = Double(i)
                    let x = radius * cos(angle * Double.pi / 180) * scaleX
                    let y = radius * sin(angle * Double.pi / 180) * scaleY
                    let location = CGPoint(x: origin.x + x, y: origin.y + y)
                    let point = PKStrokePoint(location: location, timeOffset: 0, size: CGSize(width: thikness, height: thikness), opacity: opacity, force: 0, azimuth: 0, altitude: 0)
                    controlPoints.append(point)
                }

                let strokePath = PKStrokePath(controlPoints: controlPoints, creationDate: Date())
                let stroke = PKStroke(ink: ink, path: strokePath)
                self = PKDrawing(strokes: [stroke])
            } else {
                // TODO: More variations for different tools (!)
                let path = Bundle.main.url(forResource: "circle", withExtension: "pkdrawing")!
                
                let data = try! Data(contentsOf: path)
                let drawing = try! PKDrawing(data: data)
                
                var transform = CGAffineTransformIdentity
                transform = CGAffineTransformTranslate(transform, bounds.origin.x, bounds.origin.y)
                transform = CGAffineTransformScale(transform, bounds.width/64, bounds.height/64)
                
                // TODO: Programmically select and fill with different color (?)
                
                self = drawing.transformed(using: transform)
            }
            break
        case .rectangle:
            if #available(iOS 14.0, *) {
                // draw unfilled rectangle within the bounds at origin
                
                let ink: PKInk = tool?.ink ?? PKInk(.pen, color: UIColor.systemRed)
                let size = CGSize(width: thikness, height: thikness)
                let creationDate = Date()
                                                
                let strokePath1 = PKStrokePath(controlPoints: [
                    PKStrokePoint(location: CGPoint(x: bounds.minX, y: bounds.minY), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0),
                    PKStrokePoint(location: CGPoint(x: bounds.maxX, y: bounds.minY), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0)
                ], creationDate: creationDate)
                
                let strokePath2 = PKStrokePath(controlPoints: [
                    PKStrokePoint(location: CGPoint(x: bounds.maxX, y: bounds.minY), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0),
                    PKStrokePoint(location: CGPoint(x: bounds.maxX, y: bounds.maxY), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0)
                ], creationDate: creationDate)
                
                let strokePath3 = PKStrokePath(controlPoints: [
                    PKStrokePoint(location: CGPoint(x: bounds.maxX, y: bounds.maxY), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0),
                    PKStrokePoint(location: CGPoint(x: bounds.minX, y: bounds.maxY), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0)
                ], creationDate: creationDate)
                
                let strokePath4 = PKStrokePath(controlPoints: [
                    PKStrokePoint(location: CGPoint(x: bounds.minX, y: bounds.maxY), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0),
                    PKStrokePoint(location: CGPoint(x: bounds.minX, y: bounds.minY), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0)
                ], creationDate: creationDate)

                self = PKDrawing(strokes: [
                    PKStroke(ink: ink, path: strokePath1),
                    PKStroke(ink: ink, path: strokePath2),
                    PKStroke(ink: ink, path: strokePath3),
                    PKStroke(ink: ink, path: strokePath4)
                ])
            } else {
                let path = Bundle.main.url(forResource: "square", withExtension: "pkdrawing")!
                let data = try! Data(contentsOf: path)
                let drawing = try! PKDrawing(data: data)
                
                var transform = CGAffineTransformIdentity
                transform = CGAffineTransformTranslate(transform, bounds.origin.x, bounds.origin.y)
                transform = CGAffineTransformScale(transform, bounds.width/64, bounds.height/64)
                
                self = drawing.transformed(using: transform)
            }
            break
        case .triangle:
            if #available(iOS 14.0, *) {
                // draw perfect triangle inside the bounds
                
                let ink: PKInk = tool?.ink ?? PKInk(.pen, color: UIColor.systemRed)
                let size = CGSize(width: thikness, height: thikness)
                let creationDate = Date()
                 
                let strokePath1 = PKStrokePath(controlPoints: [
                    PKStrokePoint(location: CGPoint(x: bounds.minX, y: bounds.maxY), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0),
                    PKStrokePoint(location: CGPoint(x: bounds.maxX/2, y: bounds.minY), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0)
                ], creationDate: creationDate)
                
                let strokePath2 = PKStrokePath(controlPoints: [
                    PKStrokePoint(location: CGPoint(x: bounds.maxX/2, y: bounds.minY), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0),
                    PKStrokePoint(location: CGPoint(x: bounds.maxX, y: bounds.maxY), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0)
                ], creationDate: creationDate)
                
                let strokePath3 = PKStrokePath(controlPoints: [
                    PKStrokePoint(location: CGPoint(x: bounds.maxX, y: bounds.maxY), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0),
                    PKStrokePoint(location: CGPoint(x: bounds.minX, y: bounds.maxY), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0)
                ], creationDate: creationDate)

                self = PKDrawing(strokes: [
                    PKStroke(ink: ink, path: strokePath1),
                    PKStroke(ink: ink, path: strokePath2),
                    PKStroke(ink: ink, path: strokePath3),
                ])
            } else {
                let path = Bundle.main.url(forResource: "triangle", withExtension: "pkdrawing")!
                
                let data = try! Data(contentsOf: path)
                let drawing = try! PKDrawing(data: data)
                
                var transform = CGAffineTransformIdentity
                transform = CGAffineTransformTranslate(transform, bounds.origin.x, bounds.origin.y)
                transform = CGAffineTransformScale(transform, bounds.width/64, bounds.height/64)
                
                self = drawing.transformed(using: transform)
            }
            break
        case .star:
            if #available(iOS 14.0, *) {
                // draw predefined star inside the bounds
                
                let ink: PKInk = tool?.ink ?? PKInk(.pen, color: UIColor.systemRed)
                let size = CGSize(width: thikness, height: thikness)
                let creationDate = Date()
                
                let lenght = bounds.width > bounds.height ? bounds.width : bounds.height
                
                let multiply = lenght / 3.0 // 3x3 axis used
                
                let x = bounds.origin.x
                let y = bounds.origin.y
                
                let strokePath1 = PKStrokePath(controlPoints: [
                    PKStrokePoint(location: CGPoint(x: 1.5*multiply + x, y: y), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: y),
                    PKStrokePoint(location: CGPoint(x: 2*multiply + x, y: 1*multiply + y), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0)
                ], creationDate: Date())
                
                let strokePath2 = PKStrokePath(controlPoints: [
                    PKStrokePoint(location: CGPoint(x: 2*multiply + x, y: 1*multiply + y), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0),
                    PKStrokePoint(location: CGPoint(x: 3*multiply + x, y: 1*multiply + y), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0)
                ], creationDate: creationDate)
                
                let strokePath3 = PKStrokePath(controlPoints: [
                    PKStrokePoint(location: CGPoint(x: 3*multiply + x, y: 1*multiply + y), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0),
                    PKStrokePoint(location: CGPoint(x: 2.125*multiply + x, y: 1.75*multiply + y), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0)
                ], creationDate: creationDate)
                
                let strokePath4 = PKStrokePath(controlPoints: [
                    PKStrokePoint(location: CGPoint(x: 2.125*multiply + x, y: 1.75*multiply + y), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0),
                    PKStrokePoint(location: CGPoint(x: 2.5*multiply + x, y: 3*multiply + y), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0)
                ], creationDate: creationDate)
                
                let strokePath5 = PKStrokePath(controlPoints: [
                    PKStrokePoint(location: CGPoint(x: 2.5*multiply + x, y: 3*multiply + y), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0),
                    PKStrokePoint(location: CGPoint(x: 1.5*multiply + x, y: 2.25*multiply + y), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0)
                ], creationDate: creationDate)
                
                let strokePath6 = PKStrokePath(controlPoints: [
                    PKStrokePoint(location: CGPoint(x: 1.5*multiply + x, y: 2.25*multiply + y), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0),
                    PKStrokePoint(location: CGPoint(x: 0.5*multiply + x, y: 3*multiply + y), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0)
                ], creationDate: creationDate)
                
                let strokePath7 = PKStrokePath(controlPoints: [
                    PKStrokePoint(location: CGPoint(x: 0.5*multiply + x, y: 3*multiply + y), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0),
                    PKStrokePoint(location: CGPoint(x: 0.875*multiply + x, y: 1.75*multiply + y), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0)
                ], creationDate: creationDate)
                
                let strokePath8 = PKStrokePath(controlPoints: [
                    PKStrokePoint(location: CGPoint(x: 0.875*multiply + x, y: 1.75*multiply + y), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0),
                    PKStrokePoint(location: CGPoint(x: x, y: 1*multiply + y), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0)
                ], creationDate: creationDate)
                
                let strokePath9 = PKStrokePath(controlPoints: [
                    PKStrokePoint(location: CGPoint(x: x, y: 1*multiply + y), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0),
                    PKStrokePoint(location: CGPoint(x: 1*multiply + x, y: 1*multiply + y), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0)
                ], creationDate: creationDate)
                
                let strokePath10 = PKStrokePath(controlPoints: [
                    PKStrokePoint(location: CGPoint(x: 1*multiply + x, y: 1*multiply + y), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0),
                    PKStrokePoint(location: CGPoint(x: 1.5*multiply + x, y: 0*multiply + y), timeOffset: 0, size: size, opacity: opacity, force: 0, azimuth: 0, altitude: 0)
                ], creationDate: creationDate)

                self = PKDrawing(strokes: [
                    PKStroke(ink: ink, path: strokePath1),
                    PKStroke(ink: ink, path: strokePath2),
                    PKStroke(ink: ink, path: strokePath3),
                    PKStroke(ink: ink, path: strokePath4),
                    PKStroke(ink: ink, path: strokePath5),
                    PKStroke(ink: ink, path: strokePath6),
                    PKStroke(ink: ink, path: strokePath7),
                    PKStroke(ink: ink, path: strokePath8),
                    PKStroke(ink: ink, path: strokePath9),
                    PKStroke(ink: ink, path: strokePath10),
                ])
            } else {
                let path = Bundle.main.url(forResource: "star", withExtension: "pkdrawing")!
                
                let data = try! Data(contentsOf: path)
                let drawing = try! PKDrawing(data: data)
                
                var transform = CGAffineTransformIdentity
                transform = CGAffineTransformTranslate(transform, bounds.origin.x, bounds.origin.y)
                transform = CGAffineTransformScale(transform, bounds.width/64, bounds.height/64)
                
                self = drawing.transformed(using: transform)
            }
            break
        }
    }
}

