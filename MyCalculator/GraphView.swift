//
//  GraphView.swift
//  MyCalculator
//
//  Created by Gai Carmi on 9/19/17.
//  Copyright © 2017 Gai Carmi. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    
    @IBInspectable var axesColor: UIColor = UIColor.black { didSet { setNeedsDisplay() } }
    @IBInspectable var lineWidth: CGFloat = 1.0 { didSet { setNeedsDisplay() } }
    @IBInspectable var scale: CGFloat = 50.0 { didSet { setNeedsDisplay() } }
    @IBInspectable var origin: CGPoint! { didSet { setNeedsDisplay() } }
    @IBInspectable var lineColor: UIColor = UIColor.red { didSet { setNeedsDisplay() }}
    
    var yFunction: ((Double) -> Double?)? { didSet { setNeedsDisplay() } }

    private var axesDrawer = AxesDrawer()
    
    
    
    override func draw(_ rect: CGRect) {
        origin = origin ?? CGPoint(x: bounds.midX, y: bounds.midY)
        axesDrawer.contentScaleFactor = contentScaleFactor
        axesDrawer.color = axesColor
        axesDrawer.drawAxes(in: bounds, origin: origin, pointsPerUnit: scale)
        drawGraphForGivenFunction()
        
    }
    
    func drawGraphForGivenFunction() {
        
        let path = UIBezierPath()
        var isEmptyLine = true
        lineColor.set()
        
        var graphPoint = CGPoint() // the points for the graph
        var x: Double              // the value (of points) for calculation
        let width = Int(bounds.size.width * contentScaleFactor)
        
        for pixel in 0...width {
            
            graphPoint.x = CGFloat(pixel) / contentScaleFactor
            x = (Double((graphPoint.x - origin.x) / scale))
            
            if let y = yFunction?(x){
                graphPoint.y = origin.y - CGFloat(y) * scale
                
                if isEmptyLine {
                    path.move(to: graphPoint)
                    isEmptyLine = false
                } else {
                    path.addLine(to: graphPoint)
                }
            }

        }
        
        path.lineWidth = lineWidth
        path.stroke()
    }
    
    
    
    // gestures - 3 types - for set the origin by tap, drag the origin and zoom with pinch
    
    func setOriginWithTap(recognizer: UITapGestureRecognizer){
        origin = recognizer.location(in: self)
    }
    
    func moveOrigin(recognizer: UIPanGestureRecognizer){
        
        switch recognizer.state {
            
        case .changed, .ended:
            let translation = recognizer.translation(in: self)
            origin.x += translation.x
            origin.y += translation.y
            recognizer.setTranslation(CGPoint.zero, in: self)
            
        default: break
        }
    }
    
    func scale(recognizer: UIPinchGestureRecognizer){
        
        switch recognizer.state {

        case .changed, .ended:
            scale *= recognizer.scale
            recognizer.scale = 1
            
        default: break
            
        }
    }
    
}
