//
//  InstrumentationViewController.swift
//  Assignment4
//
//  Created by Joanne Huang on 10/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController {

    @IBOutlet weak var rows: UITextField!
    @IBOutlet weak var cols: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let sel = #selector(SimulationViewController.watchForNotifications(_:))
        let center  = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: sel, name: "EngineUpdate", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didUpdateRows(sender: UITextField) {
        if let text = rows.text,
            numRows = Int(text)  {
            if numRows > 0 {
                StandardEngine.sharedInstance.rows = numRows
            }
            
            //StandardEngine.sharedInstance.grid!.rows = numRows
            
            //StandardEngine.sharedInstance.delegate!.engineDidUpdate()
           // StandardEngine.
        }
    }
    
    @IBAction func didUpdateCols(sender: UITextField) {
        if let text = cols.text,
            numCols = Int(text)  {
            if numCols > 0 {
                StandardEngine.sharedInstance.cols = numCols
            }
        }
    }
    
    @IBAction func incrementCols(sender: UIStepper) {
        if let text = cols.text,
            numCols = Int(text)  {
            cols.text = String(numCols + 10)
            StandardEngine.sharedInstance.cols = Int(cols.text!)!
            
            // should + or - 10 depending on what was clicked
            // should check new value is a valid number
        }
        else  {   // no text
            cols.text = "10"
            StandardEngine.sharedInstance.cols = 10
        }
    }
    
    @IBAction func incrementRows(sender: UIStepper) {
        if let text = rows.text,
            numRows = Int(text)  {
            rows.text = String(numRows + 10)
            StandardEngine.sharedInstance.rows = Int(rows.text!)!
            
            // should + or - 10 depending on what was clicked
            // should check new value is a valid number
        }
        else  {   // no text
            rows.text = "10"
            StandardEngine.sharedInstance.rows = 10
        }
    }

    @IBAction func changeRefreshRate(sender: UISlider) {
        StandardEngine.sharedInstance.refreshRate = Double(sender.value)
    }
    
    @IBAction func toggleTimedRefresh(sender: UISwitch) {
        if let timer = StandardEngine.sharedInstance.refreshTimer {
            timer.invalidate()
            StandardEngine.sharedInstance.refreshTimer = nil
        }
        else {
            let sel = #selector(StandardEngine.timerDidFire(_:))
            StandardEngine.sharedInstance.refreshTimer = NSTimer.scheduledTimerWithTimeInterval(
                                                                StandardEngine.sharedInstance.refreshRate,
                                                                target: self,
                                                                selector: sel,
                                                                userInfo: nil,
                                                                repeats: true)
        }
    }
    
    
}

