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
    @IBOutlet weak var timerSwitch: UISwitch!
    @IBOutlet weak var refreshRateSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let sel = #selector(InstrumentationViewController.watchForNotifications(_:))
        let center  = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: sel, name: "TimerFired", object: nil)
        // we don't really need to listen for EngineUpdate since the settings will all be the latest
        // and cannot be changed anywhere but in this view
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
            else {
                // invalid number - do nothing
            }
        }
        // else (no text, or non-integer text) do nothing
    }
    
    @IBAction func didUpdateCols(sender: UITextField) {
        if let text = cols.text,
            numCols = Int(text)  {
            if numCols > 0 {
                StandardEngine.sharedInstance.cols = numCols
            }
            else {
                // invalid number - do nothing
            }
        }
        // else (no text, or non-integer text) do nothing
    }
    
    @IBAction func incrementCols(sender: UIStepper) {
        if let text = cols.text,
            numCols = Int(text)  {
            if (sender.value == 10) {
                cols.text = String(numCols + 10)
            }
            if (sender.value == -10) {
                cols.text = String(numCols - 10)
            }

            if Int(cols.text!)! > 0 {
                StandardEngine.sharedInstance.cols = Int(cols.text!)!
            }
            else {  // got a negative number. set to smallest possible, ie. 1
                StandardEngine.sharedInstance.cols = 1
                cols.text = "1"
            }
            
            sender.value = 0  // ready for next click
        }
        else  {   // no text or invalid text - set to default
            cols.text = "10"
            StandardEngine.sharedInstance.cols = 10
        }
    }
    
    @IBAction func incrementRows(sender: UIStepper) {
        if let text = rows.text,
            numRows = Int(text)  {
            if (sender.value == 10) {
                rows.text = String(numRows + 10)
            }
            if (sender.value == -10) {
                rows.text = String(numRows - 10)
            }
            
            if Int(rows.text!)! > 0 {
                StandardEngine.sharedInstance.rows = Int(rows.text!)!
            }
            else {  // got a negative number. set to smallest possible, ie. 1
                StandardEngine.sharedInstance.rows = 1
                rows.text = "1"
            }
            
            sender.value = 0    // ready for next click
        }
        else  {   // no text or invalid text - set to default
            rows.text = "10"
            StandardEngine.sharedInstance.rows = 10
        }
    }

    @IBAction func changeRefreshRate(sender: UISlider) {
        StandardEngine.sharedInstance.refreshRate = Double(sender.value)
        
        // setting refreshRate will install a timer. Change UI to reflect that timer is now on.
        // user needs to turn it off if they want it off.
        // by default, refreshRate is 0.0, and timer is off
        timerSwitch.on = true
        
    }
    
    @IBAction func toggleTimedRefresh(sender: UISwitch) {
        if let timer = StandardEngine.sharedInstance.refreshTimer {
            timer.invalidate()
            StandardEngine.sharedInstance.refreshTimer = nil
        }
        else {
            let sel = #selector(StandardEngine.timerDidFire(_:))
            
            // THIS PART IS CAUSING A CRASH!
            
            
            // NEED TO SET REFRESH RATE TO VALUE OF SLIDER IN CASE IT HASN'T BEEN TOUCHED YET
            StandardEngine.sharedInstance.refreshRate = Double(refreshRateSlider.value)
            
            StandardEngine.sharedInstance.refreshTimer = NSTimer.scheduledTimerWithTimeInterval(
                                                                StandardEngine.sharedInstance.refreshRate,
                                                                target: self,
                                                                selector: sel,
                                                                userInfo: nil,
                                                                repeats: true)
        }
    }
    
    func watchForNotifications(notification:NSNotification) {
        // technically, this view controller doesn't need to watch for notifications?

        // SETTINGS SHOULD ALREADY BE THE LATEST - DO NOTHING
        
        // get latest grid - CHECK THIS - grid is get only, no set
        //StandardEngine.sharedInstance.grid = notification.userInfo as? GridProtocol
//        if let info = notification.userInfo {
//            StandardEngine.sharedInstance.grid! =  info as! GridProtocol
//        }
        
        let newGrid = StandardEngine.sharedInstance.step()
        StandardEngine.sharedInstance.grid = newGrid
        if let delegate = StandardEngine.sharedInstance.delegate {
            delegate.engineDidUpdate(StandardEngine.sharedInstance.grid! as! Grid)
        }
        
    }
    
}

