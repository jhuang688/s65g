//
//  GridView.swift
//  Assignment3
//
//  Created by Joanne Huang on 6/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

import UIKit

@IBDesignable class GridView: UIView {

    // default cell colours
    @IBInspectable var livingColor: UIColor = UIColor.yellowColor()
    @IBInspectable var emptyColor: UIColor = UIColor.clearColor()  // UIColor.grayColor()
    @IBInspectable var bornColor: UIColor = UIColor.greenColor()
    @IBInspectable var diedColor: UIColor = UIColor.brownColor()
    
    // colour and width of grid lines
    @IBInspectable var gridColor: UIColor = UIColor.blackColor()
    @IBInspectable var gridWidth: CGFloat = 2.0
    
    // num rows and cols - give default values to silence warnings - update with latest values later
    var cols: Int = 10
    var rows: Int = 10
    
    // used as flags for what needs to drawn
    var gridlinesDrawn = false
    var touched = false
    
    // col and row of touched cell to redraw - this is set by processTouch
    var touchCol = 0
    var touchRow = 0
    
    override func drawRect(rect: CGRect) {
        // super.drawRect(rect)  // not needed
        
        // in case they have changed, get them again
        cols = StandardEngine.sharedInstance.cols
        rows = StandardEngine.sharedInstance.rows
        
        // calculate cell size. This allows for non-square cells.
        // If they must be squares, they can both equal the minimum of the two.
        let cellWidth: CGFloat = self.frame.size.width / CGFloat(cols)
        let cellHeight: CGFloat = self.frame.size.height / CGFloat (rows)
        
        if gridlinesDrawn == false {
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
            
            gridlinesDrawn = true  // set to true to avoid unnecessary redraw
        }
        
        if touched == false {
            // draw all circles in cells
            for col in 0..<cols {
                for row in 0..<rows {
                    let aCell = CGRectMake(CGFloat(col)*cellWidth + gridWidth/2, CGFloat(row)*cellHeight + gridWidth/2, cellWidth - gridWidth, cellHeight - gridWidth)
                    
                    let circle = UIBezierPath(ovalInRect: aCell)
                    var cellColor: UIColor
                    switch (StandardEngine.sharedInstance.grid![col,row]!) {
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
        else {     // touched = true - only redraw touched cell
            let aCell = CGRectMake(CGFloat(touchCol)*cellWidth + gridWidth/2, CGFloat(touchRow)*cellHeight + gridWidth/2, cellWidth - gridWidth, cellHeight - gridWidth)
            
            let circle = UIBezierPath(ovalInRect: aCell)
            var cellColor: UIColor
            switch (StandardEngine.sharedInstance.grid![touchCol,touchRow]!) {
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
            
            touched = false  // set back to false - will be set true by processTouch as triggered
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
        let cols = StandardEngine.sharedInstance.cols
        let rows = StandardEngine.sharedInstance.rows
        
        // calculate cell size. This allows for non-square cells.
        // If they must be squares, they can both equal the minimum of the two.
        let cellWidth: CGFloat = self.frame.size.width / CGFloat(cols)
        let cellHeight: CGFloat = self.frame.size.height / CGFloat (rows)
        
        // set touchRow and touchCol
        let point: CGPoint = touch.locationInView(self)
        touchRow = Int (floor(point.y / cellHeight))
        touchCol  = Int (floor(point.x / cellWidth))
        
        // Only toggle and redraw if it is a valid cell location.
        // This avoids a crash when the user's touch begins in the grid, and moves outside,
        // a very possible accident.
        // A touch that begins outside the grid is invalid and will get no response,
        // even if it then moves inside.
        if touchRow >= 0 && touchRow < rows && touchCol >= 0 && touchCol < cols {
            // toggle touched cell in newGrid (replica of grid)
            var newGrid: GridProtocol = StandardEngine.sharedInstance.grid!
            newGrid[touchCol,touchRow]! = newGrid[touchCol,touchRow]!.toggle(newGrid[touchCol,touchRow]!)
            
            // set grid = newGrid
            StandardEngine.sharedInstance.grid = newGrid
            
//            // define cell to redraw as CGRect, set touched to true, and redraw only that cell
//            let cellToRedraw = CGRectMake(CGFloat(touchCol)*cellWidth + gridWidth/2, CGFloat(touchRow)*cellHeight + gridWidth/2, cellWidth - gridWidth, cellHeight - gridWidth)
//            touched = true
//            self.setNeedsDisplayInRect(cellToRedraw)
            
            if let delegate = StandardEngine.sharedInstance.delegate {
                delegate.engineDidUpdate(StandardEngine.sharedInstance.grid!)
            }
        }
    }
}

