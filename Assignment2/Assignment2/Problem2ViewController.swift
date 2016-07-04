//
//  Problem2ViewController.swift
//  Assignment2
//
//  Created by Joanne Huang on 29/06/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

import UIKit

class Problem2ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController!.title = "Problem 2"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This function randomly assigns 1/3 of cells to be alive to start with
    // Then it calculates the next state according to the rules of Conway's
    // Game of Life. The before and after states are represented by 2D arrays
    // of bools and the number of living cells is displayed in the text view.
    // This is used by Problem 2
    @IBAction func buttonClicked(sender: AnyObject) {
        // textView.text = "Button clicked" // for testing purposes
        
        var before: [[Bool]] = []  // 2D array of bools for the before state
        var after: [[Bool]] = []   // 2D array of bools for the after state
        
        let rows = 10              // num rows
        let columns = 10           // num cols
        
        // initialise before and after to be all false
        for _ in 0..<columns {
            before.append(Array(count:rows, repeatedValue:false))
        }
        for _ in 0..<columns {
            after.append(Array(count:rows, repeatedValue:false))
        }
        
        // randomly select 1/3 live cells in before
        for col in 0..<columns{
            for row in 0..<rows{
                if arc4random_uniform(3) == 1 {
                    before[col][row] = true
                }
            }
        }
        
        // count live cells before and display result
        var countBefore = 0
        for col in 0..<columns{
            for row in 0..<rows{
                if before[col][row] == true {
                    countBefore += 1
                }
            }
        }
        textView.text = "Number of living cells before: \(countBefore)"
        
        // check neighbours and update after
        for col in 0..<columns{
            var prevCol = col - 1   // index of previous col
            var nextCol = col + 1   // index of next col
            
            // handle wrapping rules
            if prevCol < 0 {
                prevCol = columns - 1
            }
            if nextCol > columns - 1 {
                nextCol = 0
            }
            
            for row in 0..<rows{
                var prevRow = row - 1  // index of previous row
                var nextRow = row + 1  // index of next row
                // handle wrapping rules
                if prevRow < 0 {
                    prevRow = rows - 1
                }
                if nextRow > rows - 1 {
                    nextRow = 0
                }

                // check neighbours' states and update count
                var livingNeighbours = 0    // num living neighbours
                if before[prevCol][prevRow] == true {
                    livingNeighbours += 1
                }
                if before[prevCol][row] == true {
                    livingNeighbours += 1
                }
                if before[prevCol][nextRow] == true {
                    livingNeighbours += 1
                }
                if before[col][prevRow] == true {
                    livingNeighbours += 1
                }
                if before[col][nextRow] == true {
                    livingNeighbours += 1
                }
                if before[nextCol][prevRow] == true {
                    livingNeighbours += 1
                }
                if before[nextCol][row] == true {
                    livingNeighbours += 1
                }
                if before[nextCol][nextRow] == true {
                    livingNeighbours += 1
                }
                
                // update after array accordingly - switch statement here
                switch livingNeighbours {
                case 2:   // 2 living neighbours - check current status
                    if before[col][row] == true {
                        after[col][row] = true
                    }
                    else {
                        after[col][row] = false
                    }
                case 3:  // 3 living neighbours - born or stay alive
                    after[col][row] = true
                default:  // all others - die or stay dead
                    after[col][row] = false
                }
            }
        }
        
        // count live cells after and display result
        var countAfter = 0
        for col in 0..<columns{
            for row in 0..<rows{
                if after[col][row] == true {
                    countAfter += 1
                }
            }
        }
        textView.text = textView.text + "\nNumber of living cells after: \(countAfter)"
        
    }
    
}