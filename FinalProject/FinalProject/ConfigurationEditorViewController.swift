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
    var commit: (String -> Void)?

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
        if let newTitle = nameText.text {
            if newTitle != "" {
                // update this for table display
                (self.navigationController?.viewControllers[0] as! ConfigurationViewController).titles.append(newTitle)
                (self.navigationController?.viewControllers[0] as! ConfigurationViewController).positions = gridViewForEdit.points
                (self.navigationController?.viewControllers[0] as! ConfigurationViewController).configs.append(["title": newTitle, "contents": gridViewForEdit.points.map { [$0.row, $0.col] }])
                
                // also update model grid for simulation VC and statistics VC
                var newGrid = Grid(rows: gridViewForEdit.rows, cols: gridViewForEdit.cols)
                // change alive positions to ints
                let array: [Int] = gridViewForEdit.points.map { $0.row * newGrid.cols + $0.col }
                
                // Second:
                //   Empty out actualGrid
                // Third:
                //   Set only the positions in the positions in the actualGrid to .Living
                newGrid.cells = newGrid.cells.map {
                    if array.contains($0.position.row * newGrid.cols + $0.position.col) {
                        return Cell($0.position, .Living)
                    }
                    else {
                        return Cell($0.position, .Empty)
                    }
                }
                
                newGrid.title = newTitle
                
                StandardEngine.sharedInstance.grid = newGrid
                
                // send EngineUpdate notification
                if let delegate = StandardEngine.sharedInstance.delegate {
                    delegate.engineDidUpdate(StandardEngine.sharedInstance.grid)
                }
                
                
                
                // we can do this by setting points for GridView (not GridViewDisplayOnly)
                // or some other way
                
                // take user back to instrumentation view
                self.navigationController?.popToRootViewControllerAnimated(true)
                
                
            }
            else {
                presentAlert()
            }
        }
        else {
            presentAlert()
        }

        
//        guard let newTitle = nameText.text, commit = commit
//            else { return }
//        commit(newTitle)
//        navigationController!.popViewControllerAnimated(true)
        
        // add to array of dictionaries and reload tableview
        

        // update actual grid in model, hence updating simulation and statistics views
        

    }
    
    func watchForNotifications(notification:NSNotification) {
        // re-draw
        gridViewForEdit.setNeedsDisplay()
    }
    
    func presentAlert() {
        let refreshAlert = UIAlertController(title: "Could not save", message: "Please enter a name to save this configuration", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            //print("Handle Ok logic here")
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
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
