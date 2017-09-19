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

    private var axesDrawer = AxesDrawer()
    
    override func draw(_ rect: CGRect) {
        origin = origin ?? CGPoint(x: bounds.midX, y: bounds.midY)
        axesDrawer.contentScaleFactor = contentScaleFactor
        axesDrawer.color = axesColor
        axesDrawer.drawAxes(in: bounds, origin: origin, pointsPerUnit: scale)
    }
    
}
