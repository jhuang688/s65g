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
            // re-initialise grid as all empty
            grid = []
            for _ in 0..<cols {
                grid.append(Array(count:rows, repeatedValue:.Empty))
            }
        }
    }
    @IBInspectable var cols: Int = 20 {
        didSet {
            // re-initialise grid as all empty
            grid = []
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
    @IBInspectable var gridWidth: CGFloat = 2.0
    
    var grid: [[CellState]] = []
    
    // SHOULDN'T NEED THESE
    var gridlinesDrawn = false
    var touched = false
    var touchCol = 0
    var touchRow = 0
    
    override func drawRect(rect: CGRect) {
       // super.drawRect(rect)  // not needed
        
        // calculate size
        let cellWidth: CGFloat = self.frame.size.width / CGFloat(cols)
        let cellHeight: CGFloat = self.frame.size.height / CGFloat (rows)  // in case we don't want squares someday
        
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
            
            gridlinesDrawn = true
        }

        if touched == false {
            // draw circles in cells
            for col in 0..<cols {
                for row in 0..<rows {
                    //let aCell = CGRectMake(CGFloat(col)*cellWidth, CGFloat(row)*cellHeight, cellWidth, cellHeight);
                    let aCell = CGRectMake(CGFloat(col)*cellWidth + gridWidth/2, CGFloat(row)*cellHeight + gridWidth/2, cellWidth - gridWidth, cellHeight - gridWidth)

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
        else {     // touched = true
            let aCell = CGRectMake(CGFloat(touchCol)*cellWidth + gridWidth/2, CGFloat(touchRow)*cellHeight + gridWidth/2, cellWidth - gridWidth, cellHeight - gridWidth)
            
            let circle = UIBezierPath(ovalInRect: aCell)
            var cellColor: UIColor
            switch (grid[touchCol][touchRow]) {
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
            
            touched = false
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
        // DO NOTHING
    }
    
    func processTouch(touch: UITouch) {
        // calculate size
        let cellWidth: CGFloat = self.frame.size.width / CGFloat(cols)
        let cellHeight: CGFloat = self.frame.size.height / CGFloat (rows)  // in case we don't want squares someday
        
        let point: CGPoint = touch.locationInView(self)
        touchRow = Int (floor(point.y / cellHeight))
        touchCol  = Int (floor(point.x / cellWidth))
        grid[touchCol][touchRow] = grid[touchCol][touchRow].toggle(grid[touchCol][touchRow])
        
        //let cellToRedraw: CGRect = CGRectMake(CGFloat(touchCol)*cellWidth, CGFloat(touchRow)*cellHeight, cellWidth, cellHeight)
        
        let cellToRedraw = CGRectMake(CGFloat(touchCol)*cellWidth + gridWidth/2, CGFloat(touchRow)*cellHeight + gridWidth/2, cellWidth - gridWidth, cellHeight - gridWidth)
        touched = true

        
      //  self.clearsContextBeforeDrawing = false   // doesn't work

        self.setNeedsDisplayInRect(cellToRedraw)
        
    }
    
//    override func setNeedsDisplayInRect(aCell: CGRect) {
//        
//        
//        let circle = UIBezierPath(ovalInRect: aCell)
//        var cellColor: UIColor
//        switch (grid[touchCol][touchRow]) {
//        case .Living:
//            cellColor = livingColor
//        case .Empty:
//            cellColor = emptyColor
//        case .Born:
//            cellColor = bornColor
//        case .Died:
//            cellColor = diedColor
//        }
//        cellColor.setFill()
//        circle.fill()
//        super.setNeedsDisplayInRect(aCell)
//        
//    }
}

