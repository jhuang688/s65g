//
//  FirstViewController.swift
//  Assignment4
//
//  Created by Joanne Huang on 10/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController {

    @IBOutlet weak var rows: UITextField!
    @IBOutlet weak var cols: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func incrementCols(sender: UIStepper) {
    }
    
    @IBAction func incrementRows(sender: UIStepper) {
    }

    @IBAction func changeRefreshRate(sender: UISlider) {
    }
    
    @IBAction func toggleTimedRefresh(sender: UISwitch) {
    }
}

