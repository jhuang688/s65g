//
//  StatisticsViewController.swift
//  Assignment4
//
//  Created by Joanne Huang on 10/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    @IBOutlet weak var livingCount: UILabel!
    @IBOutlet weak var diedCount: UILabel!
    @IBOutlet weak var emptyCount: UILabel!
    @IBOutlet weak var bornCount: UILabel!
    
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
    
    func watchForNotifications(notification:NSNotification) {
        //print("\(notification.userInfo)")
        // get latest grid - CHECK THIS - grid is get only, no set
        //StandardEngine.sharedInstance.grid = notification.userInfo as? GridProtocol
   
        var livingTotal = 0  // stores count of living cells
        var bornTotal = 0
        var emptyTotal = 0
        var diedTotal = 0
        
        for col in 0..<StandardEngine.sharedInstance.cols{
            for row in 0..<StandardEngine.sharedInstance.rows{
                switch StandardEngine.sharedInstance.grid![col,row]! {
                case .Living:
                    livingTotal += 1
                case .Born:
                    bornTotal += 1
                case .Empty:
                    emptyTotal += 1
                case .Died:
                    diedTotal += 1
                }
            }
        }
        
        livingCount.text = String(livingTotal)
        bornCount.text = String(bornTotal)
        emptyCount.text = String(emptyTotal)
        diedCount.text = String(diedTotal)
        
    }
}

