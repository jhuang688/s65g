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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        StandardEngine.sharedInstance.delegate = self   // SimulationVC is the delegate
        
        // subscribe to EngineUpdate notifications
        let sel = #selector(SimulationViewController.watchForNotifications(_:))
        let center  = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: sel, name: "EngineUpdate", object: nil)
        
    }
    
    func watchForNotifications(notification:NSNotification) {
        // re-draw
        gridView.setNeedsDisplay()
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
    }
    
    @IBAction func stepButtonClicked(sender: AnyObject) {
        // step
        let newGrid = StandardEngine.sharedInstance.step()
        StandardEngine.sharedInstance.grid = newGrid
        // send EngineUpdate notification
        if let delegate = StandardEngine.sharedInstance.delegate {
            delegate.engineDidUpdate(StandardEngine.sharedInstance.grid!)
        }
        
//        // TESTING AREA:
//        gridView.points = [Position(1, 3), Position(3, 5)]
//        print(gridView.points)
    }
    
    @IBAction func resetButtonClicked(sender: AnyObject) {
        // SHOULD THIS RESET GRIDVIEW ONLY AND NOT THE GRID ITSELF???
        let emptyGrid = Grid(rows: StandardEngine.sharedInstance.rows, cols: StandardEngine.sharedInstance.cols) {
            .Empty
        }
        StandardEngine.sharedInstance.grid = emptyGrid
        
        if let delegate = StandardEngine.sharedInstance.delegate {
            delegate.engineDidUpdate(StandardEngine.sharedInstance.grid!)
        }
    }
}

