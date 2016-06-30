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
        //       self.navigationController!.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClicked(sender: AnyObject) {
        // textView.text = "Button clicked" // for testing purposes
        
        var before: [[Bool]] = []
        var after: [[Bool]] = []
        
        let rows = 10
        let columns = 10
        
        // initialise before and after
        for _ in 0..<columns {
            before.append(Array(count:rows, repeatedValue:false))
        }
        for _ in 0..<columns {
            after.append(Array(count:rows, repeatedValue:false))
        }
        // randomly select 1/3 live cells
        for col in 0..<columns{
            for row in 0..<rows{
                if arc4random_uniform(3) == 1 {
                    before[col][row] = true
                }
            }
        }
        
        // count live cells before
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
            var prevCol = col - 1
            var nextCol = col + 1
            // handle wrapping rules
            if prevCol < 0 {
                prevCol = columns - 1
            }
            if nextCol > columns - 1 {
                nextCol = 0
            }
            
            for row in 0..<rows{
                var prevRow = row - 1
                var nextRow = row + 1
                // handle wrapping rules
                if prevRow < 0 {
                    prevRow = rows - 1
                }
                if nextRow > rows - 1 {
                    nextRow = 0
                }

                // check neighbours and update count
                var livingNeighbours = 0
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
                
                // update after accordingly
                switch livingNeighbours {
                case 2:   // 2 living neighbours - check current status
                    if before[col][row] == true {
                        after[col][row] = true
                    }
                    else {
                        after[col][row] = false
                    }
                case 3:
                    after[col][row] = true
                default:
                    after[col][row] = false
                }
            }
        }
        
        // count live cells after
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