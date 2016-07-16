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
        
        StandardEngine.sharedInstance.delegate = self
        
        let sel = #selector(SimulationViewController.watchForNotifications(_:))
        let center  = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: sel, name: "EngineUpdate", object: nil)

    }
    
    func watchForNotifications(notification:NSNotification) {
        
        //StandardEngine.sharedInstance.grid = notification.userInfo as? GridProtocol
//        if let info = notification.userInfo {
//            StandardEngine.sharedInstance.grid! =  info as! GridProtocol
//        }
        
        // redraw
        gridView.gridlinesDrawn = false
//        gridView.touched = false
        gridView.setNeedsDisplay()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func engineDidUpdate(withGrid: GridProtocol) {
        // publish Grid as notification
        // each controller subscribes to notifications and updates its own appearance

        let center = NSNotificationCenter.defaultCenter()

        let n = NSNotification(name: "EngineUpdate",
                               object: nil,
                               userInfo: ["gridObject": withGrid as! AnyObject])

        center.postNotification(n)
    }
    
    @IBAction func buttonClicked(sender: AnyObject) {
        let newGrid = StandardEngine.sharedInstance.step()
        StandardEngine.sharedInstance.grid = newGrid
        if let delegate = StandardEngine.sharedInstance.delegate {
            delegate.engineDidUpdate(StandardEngine.sharedInstance.grid!)
        }
    }
}

