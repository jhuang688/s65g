//
//  ViewController.swift
//  Assignment3
//
//  Created by Joanne Huang on 6/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var gridView: GridView!
    var firstClick: Bool = true  // set to false after first click

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClicked(sender: AnyObject) {

        if firstClick == true {
            // Re-initialise grid as all empty in case user has toggled before starting.
            // User can choose to toggle to customise the grid after being
            // provided with the default starting grid (random 1/3 alive)
            gridView.grid = []
            for _ in 0..<gridView.cols {
                gridView.grid.append(Array(count:gridView.rows, repeatedValue:.Empty))
            }
            
            // randomly select 1/3 live cells
            for col in 0..<gridView.cols{
                for row in 0..<gridView.rows{
                    if arc4random_uniform(3) == 1 {
                        gridView.grid[col][row] = .Living
                    }
                }
            }
            // change button text and change firstClick to false for recursion
            sender.setTitle!("Next Generation", forState:.Normal)
            firstClick = false
        }
        else {
            gridView.grid = step2(beforeArray: gridView.grid)  // get next generation
        }
        
        // THIS WORKS BUT GRIDLINES ARE REDRAWN UNNECESSARILY
        gridView.gridlinesDrawn = false
        gridView.setNeedsDisplay()
        
        // TOO COMPLEX - DOESN'T WORK
//        let cellWidth: CGFloat = gridView.frame.size.width / CGFloat(gridView.cols)
//        let cellHeight: CGFloat = gridView.frame.size.height / CGFloat (gridView.rows)
//        for col in 0..<gridView.cols {
//            for row in 0..<gridView.rows {
//                gridView.touchCol = col
//                gridView.touchRow = row
//                let cellToRedraw = CGRectMake(CGFloat(col)*cellWidth + gridView.gridWidth/2, CGFloat(row)*cellHeight + gridView.gridWidth/2, cellWidth - gridView.gridWidth, cellHeight - gridView.gridWidth)
//                gridView.touched = true
//                gridView.setNeedsDisplayInRect(cellToRedraw)
//            }
//        }

        
        // DOESN'T WORK - GRID LINES ERASED
        //gridView.setNeedsDisplayInRect(CGRectMake(0, 0, gridView.frame.size.width, gridView.frame.size.height))

    }


}

