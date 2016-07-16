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
        
        updateCounts()   // initial counts
        
        let sel = #selector(StatisticsViewController.watchForNotifications(_:))
        let center  = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: sel, name: "EngineUpdate", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func watchForNotifications(notification:NSNotification) {

        //StandardEngine.sharedInstance.grid = notification.userInfo as? GridProtocol

        updateCounts()
    }
    
    func updateCounts() {
        // stores count of each type of cell
        var livingTotal = 0
        var bornTotal = 0
        var emptyTotal = 0
        var diedTotal = 0
        
        // do the counting
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
        
        // update labels
        dispatch_async(dispatch_get_main_queue()) {
            self.livingCount.text = String(livingTotal)
            self.bornCount.text = String(bornTotal)
            self.emptyCount.text = String(emptyTotal)
            self.diedCount.text = String(diedTotal)
        }
    }
}

