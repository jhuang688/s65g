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
    
    //    // col and row of touched cell to redraw - this is set by processTouch
    //    var touchCol = 0
    //    var touchRow = 0
    
    private var newGrid = Grid(rows: 20, cols: 20) { _ in .Empty }
    
    
    var points: [Position]? {
        set {
            // First:
            //   Get the max row and col from positions added in
            //   Set the max row and col from that - double the maximum
            // safe to assume 20 by 20 ??? NO
            
            newGrid = Grid(rows: 20, cols: 20) { _ in .Empty }
            
            // change position to int
            let array: [Int] = points!.map { $0.row * newGrid.cols + $0.col }
            
            // Second:
            //   Empty out actualGrid
            // Third:
            //   Set only the positions in the positions in the actualGrid to .Living
            newGrid.cells = newGrid.cells.map {
                if array.contains($0.position.row * newGrid.cols + $0.position.col) {
                    return Cell($0.position, .Living)
                }
                else {
                    return Cell($0.position, .Empty)
                }
            }
            
            StandardEngine.sharedInstance.grid = newGrid
            
            // send EngineUpdate notification
            if let delegate = StandardEngine.sharedInstance.delegate {
                delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
            }
            
            
        }
        get {
            // RUN THIS WHEN SAVE IS CLICKED
            
            // ONLY UPDATE STANDARD ENGINE WHEN SAVE IS CLICKED
            
            
            // WHEN SAVE IS CLICKED
            // GET NEW POINTS ARRAY
            // UPDATE TABLE VIEW WITH NEW CONFIG
            // UPDATE MODEL GRID and SIMULATION VIEW / STATISTICS VIEW
            
            // WHEN CANCEL IS CLICKED
            // TABLE VIEW NOT UPDATED, NOR IS MODEL GRID / SIMULATION VIEW / STATISTICS VIEW
            
            // WHEN USER IS TOGGLING
            // UPDATE GRIDVIEW, BUT DON'T UPDATE MODEL GRID / SIMULATION VIEW / STATISTICS VIEW
            
            // return actualGrid.filter({$0 == .Living})
            var livingArray: [Position] = []
            for i in 0..<rows*cols {
                if newGrid.cells[i].state.isAlive() {
                    livingArray.append(newGrid.cells[i].position)
                }
            }
            return livingArray
        }
    }
    
    
    //            let newGrid = Grid(rows: rows, cols: cols) {
    //                for i in 0..<self.rows*self.cols {
    //                    if array.contains(i) {
    //                        return CellState.Living
    //                    }
    //                    else {
    //                        return CellState.Empty
    //                    }
    //                }
    //                return CellState.Empty   // needed to silence warnings
    //            }
    //            StandardEngine.sharedInstance.grid = newGrid
    
    
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
            //var newGrid2: GridProtocol = newGrid
            newGrid[touchRow,touchCol] = newGrid[touchRow,touchCol]!.toggle(newGrid[touchRow,touchCol]!)
            
            // send EditChanged notification if touched in instrumentation VC - don't need to go through delegate since model is not changing
            editChanged()

        }
    }
    
    // TimerFired notifications are sent by the timer
    @objc func editChanged() {
        let center = NSNotificationCenter.defaultCenter()
        let n = NSNotification(name: "EditChanged",
                               object: nil,
                               userInfo: nil)
        //                               userInfo: ["gridObject": StandardEngine.sharedInstance.grid! as! AnyObject])
        center.postNotification(n)
    }
}


