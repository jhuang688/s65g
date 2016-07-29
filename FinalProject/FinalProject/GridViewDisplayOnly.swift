//
//  GridViewDisplayOnly.swift
//  FinalProject
//
//  Created by Joanne Huang on 27/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

// This version of GridView does not modify the model grid
// It is for display purposes while editing

import UIKit

@IBDesignable class GridViewDisplayOnly: UIView {
    
    // default cell colours
    @IBInspectable var livingColor: UIColor = UIColor.yellowColor()
    @IBInspectable var emptyColor: UIColor = UIColor.clearColor()  // UIColor.grayColor()
    @IBInspectable var bornColor: UIColor = UIColor.greenColor()
    @IBInspectable var diedColor: UIColor = UIColor.brownColor()
    @IBInspectable var diseasedColor: UIColor = UIColor.redColor()
    
    // colour and width of grid lines
    @IBInspectable var gridColor: UIColor = UIColor.blackColor()
    @IBInspectable var gridWidth: CGFloat = 2.0
    
    // num rows and cols - give default values to silence warnings - update with latest values later
    var cols: Int = 20
    var rows: Int = 20
    
    private var newGrid = Grid(rows: 20, cols: 20) { _ in .Empty }
    
    
    var points: [Position] {
        set {
            // get the max row and col from positions added in. We will set to the max + 10
            let maxRow = newValue.map { $0.row }.maxElement()
            let maxCol = newValue.map { $0.col }.maxElement()
            
            var size: Int = 20 // default is 20 by 20
            
            if let maxRow = maxRow, maxCol = maxCol {
                size = max(maxRow, maxCol) + 10
                if size > 100 {
                    size = 100   // we will limit it at 100 by 100
                }
//                if size < 5 {
//                    size = 5  // provide 10 by 10 room for stepping as a minimum
//                }
            }

            // set the row and col from that - double the maximum
            newGrid = Grid(rows: size, cols: size) { _ in .Empty }
            
            // change positions to int
            let array: [Int] = newValue.map { $0.row * newGrid.cols + $0.col }
            
            // set new grid
            newGrid.cells = newGrid.cells.map {
                if array.contains($0.position.row * newGrid.cols + $0.position.col) {
                    return Cell($0.position, .Living)
                }
                else {
                    return Cell($0.position, .Empty)
                }
            }
            
            // send EditChanged notification
            editChanged()
        }
        get {
            // return array of all alive cells (includes born, living, diseased)
            var livingArray: [Position] = []
            for i in 0..<rows*cols {
                if newGrid.cells[i].state.isAlive() {
                    livingArray.append(newGrid.cells[i].position)
                }
            }
            return livingArray
        }
    }
    
    override func drawRect(rect: CGRect) {
        // super.drawRect(rect)  // not needed
        
        // get the latest values
        cols = newGrid.cols
        rows = newGrid.rows
        
        // calculate cell size. This allows for non-square cells.
        // If they must be squares, they can both equal the minimum of the two.
        let cellWidth: CGFloat = self.frame.size.width / CGFloat(cols)
        let cellHeight: CGFloat = self.frame.size.height / CGFloat (rows)
        
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
        
        
        // draw all circles in cells
        for col in 0..<cols {
            for row in 0..<rows {
                let aCell = CGRectMake(CGFloat(col)*cellWidth + gridWidth/2, CGFloat(row)*cellHeight + gridWidth/2, cellWidth - gridWidth, cellHeight - gridWidth)
                
                let circle = UIBezierPath(ovalInRect: aCell)
                var cellColor: UIColor
                switch (newGrid.cells[row * cols + col].state) {
                case .Living:
                    cellColor = livingColor
                case .Empty:
                    cellColor = emptyColor
                case .Born:
                    cellColor = bornColor
                case .Died:
                    cellColor = diedColor
                case .Diseased:
                    cellColor = diseasedColor
                }
                cellColor.setFill()
                circle.fill()
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
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
        // do nothing
    }
    
    func processTouch(touch: UITouch) {
        let cols = newGrid.cols
        let rows = newGrid.rows
        
        // calculate cell size. This allows for non-square cells.
        // If they must be squares, they can both equal the minimum of the two.
        let cellWidth: CGFloat = self.frame.size.width / CGFloat(cols)
        let cellHeight: CGFloat = self.frame.size.height / CGFloat (rows)
        
        // find touched row and col
        let point: CGPoint = touch.locationInView(self)
        let touchRow = Int (floor(point.y / cellHeight))
        let touchCol  = Int (floor(point.x / cellWidth))
        
        // Only toggle if it is a valid cell location.
        // This avoids a crash when the user's touch begins in the grid, and moves outside,
        // a very possible accident.
        // A touch that begins outside the grid is invalid and will get no response,
        // even if it then moves inside.
        if touchRow >= 0 && touchRow < rows && touchCol >= 0 && touchCol < cols {
            // toggle touched cell in newGrid (replica of grid)
            newGrid[touchRow,touchCol] = newGrid[touchRow,touchCol]!.toggle(newGrid[touchRow,touchCol]!)
            
            // send EditChanged notification if touched in instrumentation VC - don't need to go through delegate since model is not changing
            editChanged()

        }
    }
    
    // sends EditChanged notifications
    @objc func editChanged() {
        let center = NSNotificationCenter.defaultCenter()
        let n = NSNotification(name: "EditChanged",
                               object: nil,
                               userInfo: nil)
        center.postNotification(n)
    }
}


