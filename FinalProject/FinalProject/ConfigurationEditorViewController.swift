//
//  ConfigurationEditorViewController.swift
//  FinalProject
//
//  Created by Joanne Huang on 26/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

import UIKit

class ConfigurationEditorViewController: UIViewController {
    

    @IBOutlet weak var gridViewForEdit: GridViewDisplayOnly!
    @IBOutlet weak var nameText: UITextField!
    
    var nameString: String?
    var pointsArray: [Position] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // subscribe to EngineUpdate notifications
        let sel = #selector(SimulationViewController.watchForNotifications(_:))
        let center  = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: sel, name: "EditChanged", object: nil)

        // Do any additional setup after loading the view.
        
        if let name = nameString {
            nameText.text = name
        }
        
        gridViewForEdit.points = pointsArray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveClicked(sender: UIBarButtonItem) {
        // check that a name is entered. if not, alert panel
        // add to array of dictionaries and reload tableview
        // update actual grid in model, hence updating simulation and statistics views
        
        // take user back to instrumentation view
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func watchForNotifications(notification:NSNotification) {
        // re-draw
        gridViewForEdit.setNeedsDisplay()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
