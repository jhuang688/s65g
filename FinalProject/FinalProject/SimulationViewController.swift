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
        // re-draw
        gridView.setNeedsDisplay()
        nameText.text = StandardEngine.sharedInstance.grid.title
        
        // PRE-FILL NAME OF GRID HERE

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
//                               userInfo: ["gridObject": withGrid as! AnyObject])
        center.postNotification(n)
    }
    
    @IBAction func saveButtonClicked(sender: AnyObject) {
        // add to array of dictionaries and reload tableview
        
        // check that a name is entered. if not, alert panel
        if let newTitle = nameText.text {
            if newTitle != "" {
                // update this for table display
//                (self.navigationController?.viewControllers[0] as! ConfigurationViewController).titles.append(newTitle)
//                (self.navigationController?.viewControllers[0] as! ConfigurationViewController).positions = gridView.points
//                (self.navigationController?.viewControllers[0] as! ConfigurationViewController).configs.append(["title": newTitle, "contents": gridView.points.map { [$0.row, $0.col] }])
                
                // send notification with required info as dictionary
                let center = NSNotificationCenter.defaultCenter()
                let n = NSNotification(name: "SaveConfig",
                                       object: nil,
                                       userInfo: ["title": newTitle, "contents": gridView.points.map { [$0.row, $0.col] }])
                center.postNotification(n)
//                // send EngineUpdate notification
//                if let delegate = StandardEngine.sharedInstance.delegate {
//                    delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
//                }
        
                
            }
            else {
                // ALERT PANEL
            }
        }
        else {
            // ALERT PANEL
        }
        
        // take user back to instrumentation view
        tabBarController?.selectedIndex = 0
    }
    
    @IBAction func stepButtonClicked(sender: AnyObject) {
        // step
        let newGrid = StandardEngine.sharedInstance.step()
        StandardEngine.sharedInstance.grid = newGrid
        
        // send EngineUpdate notification
        if let delegate = StandardEngine.sharedInstance.delegate {
            delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
        }
        
//        //        // TESTING AREA:
//        gridView.points = [Position(1, 3), Position(3, 5)]
//        print(gridView.points)
    }
    
    @IBAction func resetButtonClicked(sender: AnyObject) {
        // SHOULD THIS RESET GRIDVIEW ONLY AND NOT THE GRID ITSELF???
        let emptyGrid = Grid(rows: StandardEngine.sharedInstance.grid.rows, cols: StandardEngine.sharedInstance.grid.cols) {_ in
            .Empty
        }
        StandardEngine.sharedInstance.grid = emptyGrid
        
        if let delegate = StandardEngine.sharedInstance.delegate {
            delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
        }
    }
}

