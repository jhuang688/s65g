//
//  ViewController.swift
//  Assignment2
//
//  Created by Joanne Huang on 28/06/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

import UIKit

class MainController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.view.backgroundColor = UIColor.whiteColor()
     //   self.navigationController!.view.alpha = 1.0
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class Problem2ViewController: UIViewController {
    
    @IBAction func buttonClicked(sender: AnyObject) {
        textView.text = "Button clicked"
        var before: [[Bool]] = []
        var after: [[Bool]] = []
        
 //       var foo = Array(count:10, repeatedValue:
  //          Array(count:10, repeatedValue:false))
        
        //var array2D = Array<Array<Int>>()
        let rows = 10
        let columns = 10
        for _ in 0..<columns {
            before.append(Array(count:rows, repeatedValue:false))
        }
        for col in 0..<columns{
            for row in 0..<rows{
                if arc4random_uniform(3) == 1 {
                    before[col][row] = true
                }
            }
        }
        
        var count = 0
        for col in 0..<columns{
            for row in 0..<rows{
                if before[col][row] == true {
                    count += 1
                }
            }
        }
        textView.text = "\(count)"
        
    }
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Problem 2"
 //       self.navigationController!.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

class Problem3ViewController: UIViewController {
    
    @IBAction func buttonClicked(sender: AnyObject) {
        textView.text = "Button clicked"
    }
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Problem 3"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

class Problem4ViewController: UIViewController {
    
    @IBAction func buttonClicked(sender: AnyObject) {
        textView.text = "Button clicked"
    }
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Problem 4"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

