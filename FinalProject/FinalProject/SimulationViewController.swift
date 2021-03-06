//
//  SimulationViewController.swift
//  FinalProject
//
//  Created by Joanne Huang on 10/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, EngineDelegateProtocol {
    
    var stdEngine: EngineProtocol!
    
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var nameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Instead, we are doing this when the app launches, not when the simulationVC loads
        //StandardEngine.sharedInstance.delegate = self   // SimulationVC is the delegate
        
        // subscribe to EngineUpdate notifications
        let sel = #selector(SimulationViewController.watchForNotifications(_:))
        let center  = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: sel, name: "EngineUpdate", object: nil)
    }
    
    func watchForNotifications(notification:NSNotification) {
        // re-draw and update grid title
        gridView.setNeedsDisplay()
        nameText.text = StandardEngine.sharedInstance.grid.title

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func engineDidUpdate(withGrid: GridProtocol) {
        // post EngineUpdate notification
        let center = NSNotificationCenter.defaultCenter()
        let n = NSNotification(name: "EngineUpdate",
                               object: nil,
                               userInfo: nil)
        center.postNotification(n)
    }
    
    @IBAction func saveButtonClicked(sender: AnyObject) {
        // check that a name is entered. if not, alert panel
        if let newTitle = nameText.text {
            if newTitle != "" {
                // send notification with required info as dictionary. The table will be updated.
                let center = NSNotificationCenter.defaultCenter()
                let n = NSNotification(name: "SaveConfig",
                                       object: nil,
                                       userInfo: ["title": newTitle, "contents": gridView.points.map { [$0.row, $0.col] }])
                center.postNotification(n)
                
                // take user back to instrumentation view
                tabBarController?.selectedIndex = 0
            }
            else {
                presentAlert()
            }
        }
        else {
            presentAlert()
        }
        

    }
    
    func presentAlert() {
        let refreshAlert = UIAlertController(title: "Could not save", message: "Please enter a name to save this configuration", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            // handle "Ok" logic here (do nothing)
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func stepButtonClicked(sender: AnyObject) {
        // step
        let newGrid = StandardEngine.sharedInstance.step()
        StandardEngine.sharedInstance.grid = newGrid
        
        // send EngineUpdate notification
        if let delegate = StandardEngine.sharedInstance.delegate {
            delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
        }
    }
    
    @IBAction func resetButtonClicked(sender: AnyObject) {
        let emptyGrid = Grid(rows: StandardEngine.sharedInstance.grid.rows, cols: StandardEngine.sharedInstance.grid.cols) {_ in
            .Empty
        }
        StandardEngine.sharedInstance.grid = emptyGrid
        
        if let delegate = StandardEngine.sharedInstance.delegate {
            delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
        }
    }
}

