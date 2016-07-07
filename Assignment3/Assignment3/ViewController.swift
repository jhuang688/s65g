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
        
        gridView.setNeedsDisplay()

    }


}

