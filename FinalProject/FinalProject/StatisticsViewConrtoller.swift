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
        self.livingCount.text = String(StandardEngine.sharedInstance.grid.living)
        self.bornCount.text = String(StandardEngine.sharedInstance.grid.born)
        self.emptyCount.text = String(StandardEngine.sharedInstance.grid.empty)
        self.diedCount.text = String(StandardEngine.sharedInstance.grid.died)
        self.diseasedCount.text = String(StandardEngine.sharedInstance.grid.diseased)
    }
}

