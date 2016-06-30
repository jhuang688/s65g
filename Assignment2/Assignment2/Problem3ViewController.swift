//
//  Problem3ViewController.swift
//  Assignment2
//
//  Created by Joanne Huang on 29/06/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

import UIKit

class Problem3ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController!.title = "Problem 3"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClicked(sender: AnyObject) {
        // textView.text = "Button clicked"  // for testing purposes
        
        // prepare beforeArray to be passed to step
        var before: [[Bool]] = []
        
        let rows = 10
        let columns = 10
        
        for _ in 0..<columns {
            before.append(Array(count:rows, repeatedValue:false))
        }
        
        // randomly select 1/3 live cells
        for col in 0..<columns{
            for row in 0..<rows{
                if arc4random_uniform(3) == 1 {
                    before[col][row] = true
                }
            }
        }
        
        // pass before to step to get after
        var after: [[Bool]] = step(beforeArray: before)
        
        // count live cells before
        var countBefore = 0
        for col in 0..<columns{
            for row in 0..<rows{
                if before[col][row] == true {
                    countBefore += 1
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
        textView.text = "Number of living cells before: \(countBefore)" +
                        "\nNumber of living cells after: \(countAfter)"
        
    }
    
    
}