//
//  InstrumentationViewController.swift
//  FinalProject
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
        
        // subscribe to TimerFired notifications
        // We don't need to listen for EngineUpdate notifications since the settings
        // will always be whatever was set last and cannot be changed anywhere but in this view
        // We will use this view controller to handle TimerFired notifications
        let sel = #selector(InstrumentationViewController.watchForNotifications(_:))
        let center  = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: sel, name: "TimerFired", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // updates from text field
    @IBAction func didUpdateRows(sender: UITextField) {
        if let text = rows.text,
            numRows = Int(text)  {
            if numRows > 0 && numRows <= 50 {   // set between 1 and 50
                StandardEngine.sharedInstance.rows = numRows
            }
            else if numRows <= 0 {   // number too small. set to smallest possible, ie. 1
                StandardEngine.sharedInstance.rows = 1
                rows.text = "1"
            }
            else { // numRows > 50 { // number too large. set to largest possible, ie. 50
                StandardEngine.sharedInstance.rows = 50
                rows.text = "50"
            }
        }
        else { // else (no text, or non-integer text) - set to default
            rows.text = "10"
            StandardEngine.sharedInstance.rows = 10
        }
    }
    
    // updates from text field
    @IBAction func didUpdateCols(sender: UITextField) {
        if let text = cols.text,
            numCols = Int(text)  {
            if numCols > 0 && numCols <= 50 {   // set between 1 and 50
                StandardEngine.sharedInstance.cols = numCols
            }
            else if numCols <= 0 {   // number too small. set to smallest possible, ie. 1
                StandardEngine.sharedInstance.cols = 1
                cols.text = "1"
            }
            else { // numCols > 50 { // number too large. set to largest possible, ie. 50
                StandardEngine.sharedInstance.cols = 50
                cols.text = "50"
            }
        }
        else { // else (no text, or non-integer text) - set to default
            cols.text = "10"
            StandardEngine.sharedInstance.cols = 10
        }
    }
    
    // updates from stepper
    @IBAction func incrementCols(sender: UIStepper) {
        if let text = cols.text,
            numCols = Int(text)  {
            if (sender.value == 10) {
                cols.text = String(numCols + 10)
            }
            if (sender.value == -10) {
                cols.text = String(numCols - 10)
            }
            
            if Int(cols.text!)! > 0 && Int(cols.text!)! <= 50 {  // set between 1 and 50
                StandardEngine.sharedInstance.cols = Int(cols.text!)!
            }
            else if Int(cols.text!)! <= 0 {  // number too small. set to smallest possible, ie. 1
                StandardEngine.sharedInstance.cols = 1
                cols.text = "1"
            }
            else { // Int(cols.text!)! > 50 {   // number too large. set to largest possible, ie. 50
                StandardEngine.sharedInstance.cols = 50
                cols.text = "50"
            }
            sender.value = 0  // reset, ready for next click
        }
        else  {   // no text or invalid text - set to default
            cols.text = "10"
            StandardEngine.sharedInstance.cols = 10
        }
    }
    
    // updates from stepper
    @IBAction func incrementRows(sender: UIStepper) {
        if let text = rows.text,
            numRows = Int(text)  {
            if (sender.value == 10) {
                rows.text = String(numRows + 10)
            }
            if (sender.value == -10) {
                rows.text = String(numRows - 10)
            }
            
            if Int(rows.text!)! > 0 && Int(rows.text!)! <= 50 {  // set between 1 and 50
                StandardEngine.sharedInstance.rows = Int(rows.text!)!
            }
            else if Int(rows.text!)! <= 0 {  // number too small. set to smallest possible, ie. 1
                StandardEngine.sharedInstance.rows = 1
                rows.text = "1"
            }
            else { // Int(rows.text!)! > 50 {   // number too large. set to largest possible, ie. 50
                StandardEngine.sharedInstance.rows = 50
                rows.text = "50"
            }
            
            sender.value = 0    // reset, ready for next click
        }
        else  {   // no text or invalid text - set to default
            rows.text = "10"
            StandardEngine.sharedInstance.rows = 10
        }
    }
    
    @IBAction func changeRefreshRate(sender: UISlider) {
        
        // Setting refreshRate will install a timer. Change UI to reflect that timer is now on.
        // User needs to turn it off if they want it off.
        // By default, refreshRate is 0.0, and timer is off
        StandardEngine.sharedInstance.refreshRate = Double(sender.value)
        timerSwitch.on = true
        
    }
    
    @IBAction func toggleTimedRefresh(sender: UISwitch) {
        if let _ = StandardEngine.sharedInstance.refreshTimer {
            // this will remove the timer in refreshRate's didSet
            StandardEngine.sharedInstance.refreshRate = 0.0
        }
        else {
            // this will set the timer in refreshRate's didSet
            StandardEngine.sharedInstance.refreshRate = Double(refreshRateSlider.value)
        }
    }
    
    func watchForNotifications(notification:NSNotification) {
        // step
        let newGrid = StandardEngine.sharedInstance.step()
        StandardEngine.sharedInstance.grid = newGrid
        // send EngineUpdate notification
        if let delegate = StandardEngine.sharedInstance.delegate {
            delegate.engineDidUpdate(StandardEngine.sharedInstance.grid!)
        }
        
    }
    
}

