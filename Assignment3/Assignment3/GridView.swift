//
//  GridView.swift
//  Assignment3
//
//  Created by Joanne Huang on 6/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

import UIKit

@IBDesignable class GridView: UIView {
    @IBInspectable var rows: Int = 20 {
        didSet {
            // re-initialise array as all empty
            for _ in 0..<cols {
                grid.append(Array(count:rows, repeatedValue:.Empty))
            }
        }
    }
    @IBInspectable var cols: Int = 20 {
        didSet {
            // re-initialise array as all empty
            for _ in 0..<cols {
                grid.append(Array(count:rows, repeatedValue:.Empty))
            }
        }
    }
    
    @IBInspectable var livingColor: UIColor = UIColor.yellowColor()
    @IBInspectable var emptyColor: UIColor = UIColor.grayColor()  //UIColor.clearColor()
    @IBInspectable var bornColor: UIColor = UIColor.greenColor()
    @IBInspectable var diedColor: UIColor = UIColor.brownColor()
    
    @IBInspectable var gridColor: UIColor = UIColor.grayColor()
    @IBInspectable var gridWidth: CGFloat = 2.0   // what initial value?
    
    var grid: [[CellState]] = []
    
    override func drawRect(rect: CGRect) {
       // super.drawRect(CGRect)  // not needed?
        
        // calculate size
        let cellWidth: CGFloat = self.frame.size.width / CGFloat(cols)
        let cellHeight = cellWidth    // not really necessary - easier to read logic
        
        
        // draw gridlines
        let gridLines = UIBezierPath()
        
        gridLines.lineWidth = gridWidth
        
        for col in 0...cols {
            gridLines.moveToPoint(CGPoint(x: CGFloat(col) * cellWidth, y: 0))
            gridLines.addLineToPoint(CGPoint(x: CGFloat(col) * cellWidth, y: CGFloat(rows) * cellHeight))
        }
        
        for row in 0...rows {
            gridLines.moveToPoint(CGPoint(x: 0, y: CGFloat(row) * cellHeight))
            gridLines.addLineToPoint(CGPoint(x: CGFloat(cols) * cellWidth, y: CGFloat(row) * cellHeight))
        }
        
        gridColor.setStroke()
        gridLines.stroke()
 

        // draw circles in cells
        
        for col in 0..<cols {
            for row in 0..<rows {
                let aCell = CGRectMake(CGFloat(col)*cellWidth, CGFloat(row)*cellHeight, cellWidth, cellHeight);

                let circle = UIBezierPath(ovalInRect: aCell)
                var cellColor: UIColor
                switch (grid[col][row]) {
                case .Living:
                    cellColor = livingColor
                case .Empty:
                    cellColor = emptyColor
                case .Born:
                    cellColor = bornColor
                case .Died:
                    cellColor = diedColor
                }
                cellColor.setFill()
                circle.fill()
            }
        }
    }
    
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        let touch = touches.anyObject()! as UITouch
//        let location = touch.locationInView(self)
//    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//          if let touch = touches.first {
//          }

        for touch in touches {
            self.processTouch(touch)
        }

    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            self.processTouch(touch)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // DO NOTHING
    }
    
    func processTouch(touch: UITouch) {
        
        // calculate size - need to make this redundant??
        let cellWidth: CGFloat = self.frame.size.width / CGFloat(cols)
        let cellHeight = cellWidth    // not really necessary - easier to read logic
        
        let point: CGPoint = touch.locationInView(self)
        let row: Int = Int (floor(point.y / cellHeight))
        let col: Int = Int (floor(point.x / cellWidth))
        grid[col][row] = grid[col][row].toggle(grid[col][row])
        self.setNeedsDisplay()
    }
}

