//
//  SimulationViewController.swift
//  Assignment4
//
//  Created by Joanne Huang on 10/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, EngineDelegateProtocol {

    var stdEngine: EngineProtocol!

    @IBOutlet weak var gridView: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        stdEngine = StandardEngine.sharedInstance
        stdEngine.delegate = self
        
        let sel = #selector(SimulationViewController.watchForNotifications(_:))
        let center  = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: sel, name: "EngineUpdate", object: nil)
        
        //gridView.setNeedsDisplay()

    }
    
//    override func viewWillAppear(animated: Bool) {
//        gridView.gridlinesDrawn = false
//        gridView.setNeedsDisplay()
//    }
    
    func watchForNotifications(notification:NSNotification) {
        
        // get latest grid - CHECK THIS - grid is get only, no set
        //StandardEngine.sharedInstance.grid = notification.userInfo as? GridProtocol
        if let info = notification.userInfo {
            StandardEngine.sharedInstance.grid! =  info as! GridProtocol
        }
        gridView.gridlinesDrawn = false
        gridView.setNeedsDisplay()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func engineDidUpdate(withGrid: Grid) {
        // publish Grid as notification
        // each controller subscribes to notifications and updates its own appearance
        //gridView.setNeedsDisplay()
        
        
        // PROBLEM HERE - THROWING NSException
        let center = NSNotificationCenter.defaultCenter()
//        let n = NSNotification(name: "EngineUpdate",
//                               object: nil,
//                               userInfo: ["gridObject": (withGrid as? AnyObject)!])
        //center.postNotificationName("EngineUpdate", object: nil, userInfo: ["gridObject":withGrid])
        let n = NSNotification(name: "EngineUpdate",
                               object: nil,
                               userInfo: ["gridObject": withGrid])
        center.postNotification(n)
    }
    
    @IBAction func buttonClicked(sender: AnyObject) {
        let newGrid = StandardEngine.sharedInstance.step()
        StandardEngine.sharedInstance.grid = newGrid
        if let delegate = StandardEngine.sharedInstance.delegate {
            delegate.engineDidUpdate(StandardEngine.sharedInstance.grid! as! Grid)
        }
    }
}

