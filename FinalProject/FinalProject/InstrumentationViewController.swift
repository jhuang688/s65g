//
//  InstrumentationViewController.swift
//  FinalProject
//
//  Created by Joanne Huang on 10/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController {
    
//    @IBOutlet weak var rows: UITextField!
//    @IBOutlet weak var cols: UITextField!
//    @IBOutlet weak var timerSwitch: UISwitch!
//    @IBOutlet weak var refreshRateSlider: UISlider!
    
    @IBOutlet weak var rows: UITextField!
    @IBOutlet weak var cols: UITextField!
    @IBOutlet weak var timerSwitch: UISwitch!
    @IBOutlet weak var refreshRateSlider: UISlider!
    @IBOutlet weak var urlText: UITextField!
    
//    private var jsonInfo: NSMutableArray = [] //[NSDictionary] = []
//    private var parsedJSON: NSObject?
    
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
            if numRows > 0 && numRows <= 100 {   // set between 1 and 100
                StandardEngine.sharedInstance.rows = numRows
            }
            else if numRows <= 0 {   // number too small. set to smallest possible, ie. 1
                StandardEngine.sharedInstance.rows = 1
                rows.text = "1"
            }
            else { // numRows > 100 { // number too large. set to largest possible, ie. 100
                StandardEngine.sharedInstance.rows = 100
                rows.text = "100"
            }
        }
        else { // else (no text, or non-integer text) - set to default
            rows.text = "20"
            StandardEngine.sharedInstance.rows = 20
        }
    }
    

    
    // updates from text field
    @IBAction func didUpdateCols(sender: UITextField) {
        if let text = cols.text,
            numCols = Int(text)  {
            if numCols > 0 && numCols <= 100 {   // set between 1 and 100
                StandardEngine.sharedInstance.cols = numCols
            }
            else if numCols <= 0 {   // number too small. set to smallest possible, ie. 1
                StandardEngine.sharedInstance.cols = 1
                cols.text = "1"
            }
            else { // numCols > 100 { // number too large. set to largest possible, ie. 100
                StandardEngine.sharedInstance.cols = 100
                cols.text = "100"
            }
        }
        else { // else (no text, or non-integer text) - set to default
            cols.text = "20"
            StandardEngine.sharedInstance.cols = 20
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
            
            if Int(rows.text!)! > 0 && Int(rows.text!)! <= 100 {  // set between 1 and 100
                StandardEngine.sharedInstance.rows = Int(rows.text!)!
            }
            else if Int(rows.text!)! <= 0 {  // number too small. set to smallest possible, ie. 1
                StandardEngine.sharedInstance.rows = 1
                rows.text = "1"
            }
            else { // Int(rows.text!)! > 100 {   // number too large. set to largest possible, ie. 100
                StandardEngine.sharedInstance.rows = 100
                rows.text = "100"
            }
            
            sender.value = 0    // reset, ready for next click
        }
        else  {   // no text or invalid text - set to default
            rows.text = "20"
            StandardEngine.sharedInstance.rows = 20
            sender.value = 0    // reset, ready for next click
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
            
            if Int(cols.text!)! > 0 && Int(cols.text!)! <= 100 {  // set between 1 and 100
                StandardEngine.sharedInstance.cols = Int(cols.text!)!
            }
            else if Int(cols.text!)! <= 0 {  // number too small. set to smallest possible, ie. 1
                StandardEngine.sharedInstance.cols = 1
                cols.text = "1"
            }
            else { // Int(cols.text!)! > 100 {   // number too large. set to largest possible, ie. 100
                StandardEngine.sharedInstance.cols = 100
                cols.text = "100"
            }
            sender.value = 0  // reset, ready for next click
        }
        else  {   // no text or invalid text - set to default
            cols.text = "20"
            StandardEngine.sharedInstance.cols = 20
            sender.value = 0    // reset, ready for next click
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
    
    @IBAction func toggleDiseaseSwitch(sender: UISwitch) {
        if sender.on == true {
            // select 1/50 random cells to be diseased
            var newGrid = Grid(rows: StandardEngine.sharedInstance.rows, cols: StandardEngine.sharedInstance.cols) { _ in .Empty }
            newGrid.cells = StandardEngine.sharedInstance.grid.cells.map {
                if arc4random_uniform(50) == 1 {    // diseased cells will stay diseased
                    return Cell($0.position, .Diseased)
                }
                else {
                    return Cell($0.position, $0.state)
                }
            }
            StandardEngine.sharedInstance.grid = newGrid
            
            // send EngineUpdate notification
            if let delegate = StandardEngine.sharedInstance.delegate {
                delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
            }
        }
        else {
            // change all diseased cells to living
            var newGrid = Grid(rows: StandardEngine.sharedInstance.rows, cols: StandardEngine.sharedInstance.cols) { _ in .Empty }
            newGrid.cells = StandardEngine.sharedInstance.grid.cells.map {
                if $0.state == .Diseased {    // diseased cells will stay diseased
                    return Cell($0.position, .Living)
                }
                else {
                    return Cell($0.position, $0.state)
                }
            }
            StandardEngine.sharedInstance.grid = newGrid
            
            // send EngineUpdate notification
            if let delegate = StandardEngine.sharedInstance.delegate {
                delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
            }
        }
    }
    
    @IBAction func reloadClicked(sender: UIButton) {

        if let urlTyped = urlText.text {
            if urlTyped != "" {
                // send notification with url text for ConfigurationViewController
                let center = NSNotificationCenter.defaultCenter()
                let n = NSNotification(name: "ReloadURL",
                                       object: nil,
                                       userInfo: ["url": urlTyped])
                center.postNotification(n)
                
            }
        }
        

    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
////        
////        
////        
////        // default URL if nothing is provided
////        var url = NSURL(string: "https://dl.dropboxusercontent.com/u/7544475/S65g.json")!
////        
////        // use provided URL if provided
////        if let urlTyped = urlText.text {
////            if urlTyped != "" {
////                url = NSURL(string: urlTyped)!
////            }
////        }
////        
////        let fetcher = Fetcher()
////        fetcher.requestJSON(url) { (json, message) in
////            let op = NSBlockOperation {
////                if let json = json {
////                    // erase array of dictionaries
////                    
////                    // update array with new values
////                    
////                    // reload table
////                    
////                    //var array: NSArray = json[0] as NSArray //parsedJSON =
////                    //let array = json as! NSArray
////                    // THIS WORKS:
////                    self.rows.text = (json as! NSMutableArray)[0]["title"] as? String
////                    self.jsonInfo = json as! NSMutableArray
////                    self.parsedJSON = json
////                    
////                    //                    if let vc = container.segue.destinationViewController as? UINavigationController
////                    //                        where segue.identifier == "EmbedSegue" {
////                    //                        let vcs = vc.childViewControllers
////                    //                        for vc in vcs {
////                    //                            if vc.isKindOfClass(ConfigurationViewController) {
////                    //                                (vc as! ConfigurationViewController).configs = jsonInfo
////                    //                                (vc as! ConfigurationViewController).viewWillAppear(true)
////                    //                            }
////                    //                        }
////                    //let table : ConfigurationViewController = self.childViewControllers[1] as! ConfigurationViewController
////                    //table.reloadData()
////                    //table.viewWillAppear(true)
////                }
////                else if let message = message {
////                    // handle errors here - ALERT PANEL!
////                    
////                    self.rows.text = message
////                }
////                else {
////                    // handle errors here - ALERT PANEL!
////                    
////                    self.rows.text = "WTF?"
////                }
////            }
////            NSOperationQueue.mainQueue().addOperation(op)
////        }
//
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        if let vc = segue.destinationViewController as? UINavigationController
//            where segue.identifier == "EmbedSegue" {
//            
//            let vcs = vc.childViewControllers
//            for vc in vcs {
//                if vc.isKindOfClass(ConfigurationViewController) {
//                    (vc as! ConfigurationViewController).parsedJSON = parsedJSON
//                    (vc as! ConfigurationViewController).configs = jsonInfo
//                    (vc as! ConfigurationViewController).tableView.reloadData()
//                    (vc as! ConfigurationViewController).viewWillAppear(true)
//                }
//            }
// 
//            //self.embeddedViewController = vc
//            //vc.delegate = self
//        }
//    }
    
    
    func watchForNotifications(notification:NSNotification) {
        // step
        let newGrid = StandardEngine.sharedInstance.step()
        StandardEngine.sharedInstance.grid = newGrid
        // send EngineUpdate notification
        if let delegate = StandardEngine.sharedInstance.delegate {
            delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
        }
        
    }
    
}

