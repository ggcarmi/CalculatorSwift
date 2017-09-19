//
//  GraphView.swift
//  MyCalculator
//
//  Created by Gai Carmi on 9/19/17.
//  Copyright © 2017 Gai Carmi. All rights reserved.
//

import UIKit

class GraphView: UIView {
    
    var axesColor: UIColor = UIColor.black { didSet { setNeedsDisplay() } }
    var lineWidth: CGFloat = 1.0 { didSet { setNeedsDisplay() } }
    var scale: CGFloat = 50.0 { didSet { setNeedsDisplay() } }
    var origin: CGPoint! { didSet { setNeedsDisplay() } }
    var lineColor: UIColor = UIColor.red { didSet { setNeedsDisplay() }}


    private var axesDrawer = AxesDrawer()
    
    override func draw(_ rect: CGRect) {
        origin = origin ?? CGPoint(x: bounds.midX, y: bounds.midY)
        axesDrawer.contentScaleFactor = contentScaleFactor
        axesDrawer.color = axesColor
        axesDrawer.drawAxes(in: bounds, origin: origin, pointsPerUnit: scale)
        drawGraphForGivenFunction()
        
    }
    
    var yFunction: ((Double) -> Double?)? { didSet { setNeedsDisplay() } }

    func drawGraphForGivenFunction() {
        
        // add protection fot infinity,zero,discontionue
        
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
    

    
    
    
}
