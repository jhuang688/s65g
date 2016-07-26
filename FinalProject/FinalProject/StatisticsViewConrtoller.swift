//
//  StatisticsViewController.swift
//  FinalProject
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
    @IBOutlet weak var diseasedCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        updateCounts()   // initial counts
        
        // subscribe to EngineUpdate notifications
        let sel = #selector(StatisticsViewController.watchForNotifications(_:))
        let center  = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: sel, name: "EngineUpdate", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func watchForNotifications(notification:NSNotification) {
        updateCounts()
    }
    
    // this function recounts and updates the labels on statistics view
    func updateCounts() {
//        // stores count of each type of cell
//        var livingTotal = 0
//        var bornTotal = 0
//        var emptyTotal = 0
//        var diedTotal = 0
//        
//        // do the counting
//        
//        for col in 0..<StandardEngine.sharedInstance.cols{
//            for row in 0..<StandardEngine.sharedInstance.rows{
//                switch StandardEngine.sharedInstance.grid![row,col]!.state {
//                case .Living:
//                    livingTotal += 1
//                case .Born:
//                    bornTotal += 1
//                case .Empty:
//                    emptyTotal += 1
//                case .Died:
//                    diedTotal += 1
//                }
//            }
//        }
//        
//        // update labels
//        dispatch_async(dispatch_get_main_queue()) {
//            self.livingCount.text = String(livingTotal)
//            self.bornCount.text = String(bornTotal)
//            self.emptyCount.text = String(emptyTotal)
//            self.diedCount.text = String(diedTotal)
//        }
        
//        var living:  Int { return StandardEngine.sharedInstance.grid!.cells.reduce(0) { return  $1.state == .Living  ?  $0 + 1 : $0 } }
//        var born:   Int { return StandardEngine.sharedInstance.grid!.cells.reduce(0) { return  $1.state == .Born   ?  $0 + 1 : $0 } }
//        var died:   Int { return StandardEngine.sharedInstance.grid!.cells.reduce(0) { return  $1.state == .Died   ?  $0 + 1 : $0 } }
//        var empty:  Int { return StandardEngine.sharedInstance.grid!.cells.reduce(0) { return  $1.state == .Empty  ?  $0 + 1 : $0 } }
//        
//        self.livingCount.text = String(living)
//        self.bornCount.text = String(born)
//        self.emptyCount.text = String(empty)
//        self.diedCount.text = String(died)
        
        self.livingCount.text = String(StandardEngine.sharedInstance.grid.living)
        self.bornCount.text = String(StandardEngine.sharedInstance.grid.born)
        self.emptyCount.text = String(StandardEngine.sharedInstance.grid.empty)
        self.diedCount.text = String(StandardEngine.sharedInstance.grid.died)
        self.diseasedCount.text = String(StandardEngine.sharedInstance.grid.diseased)
    }
}

