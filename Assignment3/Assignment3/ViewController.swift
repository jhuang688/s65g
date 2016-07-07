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
    var firstClick: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClicked(sender: AnyObject) {

        // If first click, prepare the randomly 1/3 alive array and display it
        if firstClick == true {
            //var before: [[CellState]] = []   // before array to be passed to step
        
            //let rows = gridView.rows     // num rows
            //let columns = gridView.cols    // num cols
        
            // initialise before array as all empty
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
            firstClick = false
        }
        // pass before to step2 to get after
        // var after: [[CellState]] = step2(beforeArray: before)  // array representing after state
        else {
            gridView.grid = step2(beforeArray: gridView.grid)
        }
        
        gridView.setNeedsDisplay()
        

    }


}

