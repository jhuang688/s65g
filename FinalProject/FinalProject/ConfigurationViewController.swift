//
//  ConfigurationViewController.swift
//  FinalProject
//
//  Created by Joanne Huang on 26/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

import UIKit

class ConfigurationViewController: UITableViewController {
    
//    private var configs: Array<Dictionary<String,AnyObject>> = []
    private var titles: Array<String> = []
    
    var urlString: String? {
        didSet {

            let url = NSURL(string: urlString!)!

            let fetcher = Fetcher()
            fetcher.requestJSON(url) { (json, message) in
                if let json = json,
                    topArray = json as? Array<Dictionary<String,AnyObject>> {
                    for i in 0..<topArray.count {
                        self.titles.append(topArray[i]["title"] as! String)
                    }
                    let op = NSBlockOperation {
                        self.tableView.reloadData()
                    }
                    NSOperationQueue.mainQueue().addOperation(op)
                }
                else if let message = message {
                    // handle errors here - ALERT PANEL!
                    print(message)
                    //self.rows.text = message
                }
                else {
                    // handle errors here - ALERT PANEL!
                    print("wtf")
                    //self.rows.text = "WTF?"
                }
            }
            
//            let url = NSURL(string: urlString!)!
//            
//            //            // use provided URL if provided
//            //            if let urlTyped = urlText.text {
//            //                if urlTyped != "" {
//            //                    url = NSURL(string: urlTyped)!
//            //                }
//            //            }
//            let fetcher = Fetcher()
//            fetcher.requestJSON(url) { (json, message) in
//                if let json = json,
//                    arr = json as? NSArray {
//                    //dict = json as? Dictionary<String,AnyObject> {
//                    for i in 0..<arr.count {
//                        let dict = arr[i] as! Dictionary<String,AnyObject>
//                        let keys = dict.keys
//                        self.configs = Array(keys)
//                        let op = NSBlockOperation {
//                            self.tableView.reloadData()
//                        }
//                        NSOperationQueue.mainQueue().addOperation(op)
//                    }
//                }
//                else if let message = message {
//                    // handle errors here - ALERT PANEL!
//                    print(message)
//                    //self.rows.text = message
//                }
//                else {
//                    // handle errors here - ALERT PANEL!
//                    print("wtf")
//                    //self.rows.text = "WTF?"
//                }
//            }
//            fetcher.requestJSON(url) { (json, message) in
//                let op = NSBlockOperation {
//                    if let json = json {
                        // erase array of dictionaries
                        
                        // update array with new values
                        
                        // reload table
                        
                        //var array: NSArray = json[0] as NSArray //parsedJSON =
                        //let array = json as! NSArray
                        // THIS WORKS:
//                        self.rows.text = (json as! NSMutableArray)[0]["title"] as? String
//                        self.jsonInfo = json as! NSMutableArray //[NSDictionary]
//                        self.parsedJSON = json
//                        
//                        (self.childViewControllers[1] as! ConfigurationViewController).parsedJSON = json
//                        (self.childViewControllers[1] as! ConfigurationViewController).tableView.reloadData()
            
                        // ConfigurationViewController.parsedJ
                        
                        //                    if let vc = container.segue.destinationViewController as? UINavigationController
                        //                        where segue.identifier == "EmbedSegue" {
                        //                        let vcs = vc.childViewControllers
                        //                        for vc in vcs {
                        //                            if vc.isKindOfClass(ConfigurationViewController) {
                        //                                (vc as! ConfigurationViewController).configs = jsonInfo
                        //                                (vc as! ConfigurationViewController).viewWillAppear(true)
                        //                            }
                        //                        }
                        //let table : ConfigurationViewController = self.childViewControllers[1] as! ConfigurationViewController
                        //table.reloadData()
                        //table.viewWillAppear(true)
//
//                }
//                NSOperationQueue.mainQueue().addOperation(op)
//            }
        }
    }
    //private var configs: [NSDictionary] = []

//    var parsedJSON: NSObject? = [] {
//        didSet {
//            viewWillAppear(true)
//        }
//    }
    @IBOutlet weak var addButton: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set default string. Loads on app launch.
        urlString = "https://dl.dropboxusercontent.com/u/7544475/S65g.json"
        // urlString = "http://api.openweathermap.org/data/2.5/weather?q=boston,%20ma&appid=77e555f36584bc0c3d55e1e584960580"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewWillAppear(animated: Bool) {
//        tableView.reloadData()
//    }
    
    override func viewDidAppear(animated: Bool) {
//        let url = NSURL(string: "https://dl.dropboxusercontent.com/u/7544475/S65g.json")!
//        let fetcher = Fetcher()
//        fetcher.requestJSON(url) { (json, message) in
//            if let json = json,
//                dict = json as? Dictionary<String,AnyObject> {
//                let keys = dict.keys
//                self.configs = Array(keys)
//                let op = NSBlockOperation {
//                    self.tableView.reloadData()
//                }
//                NSOperationQueue.mainQueue().addOperation(op)
//            }
//            else if let message = message {
//                // handle errors here - ALERT PANEL!
//                print(message)
//                //self.rows.text = message
//            }
//            else {
//                // handle errors here - ALERT PANEL!
//                print("wtf")
//                //self.rows.text = "WTF?"
//            }
//        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        if let parsedJSON = parsedJSON {
//            return (parsedJSON as! NSArray).count
//        }
//        else {
//            return 0
//        }
        return titles.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        guard let editingVC = segue.destinationViewController as? ConfigurationEditorViewController
            else {
                preconditionFailure("Another wtf?")
        }
        if segue.identifier == "newConfig" {
            editingVC.navigationItem.title = "New Configuration"
        }
        else {
            let editingRow = (sender as! UITableViewCell).tag
            let editingString = titles[editingRow]
            editingVC.nameText.text = editingString
            
        }
//        editingVC.commit = {
//            self.configs[editingRow] = $0
//            let indexPath = NSIndexPath(forRow: editingRow, inSection: 0)
//            self.tableView.reloadRowsAtIndexPaths([indexPath],
//                                                  withRowAnimation: .Automatic)
//        }
        

//    }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("Default")
            else {
                preconditionFailure("missing Default reuse identifier")
        }
        let row = indexPath.row
        guard let nameLabel = cell.textLabel else {
            preconditionFailure("wtf?")
        }
        nameLabel.text = titles[row]
        cell.tag = row
        return cell
    }
    
    @IBAction func addConfig(sender: AnyObject) {
//        configs.append("Add new name...")
//        let itemRow = configs.count - 1
//        let itemPath = NSIndexPath(forRow:itemRow, inSection: 0)
//        tableView.insertRowsAtIndexPaths([itemPath], withRowAnimation: .Automatic)
        
        // SHOULD BE UPON SAVE INSTEAD!!! NOT ADD!!!
    }
    
    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                                               forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
        //    (configs as! NSMutableArray).removeObjectAtIndex(indexPath.row) //.removeAtIndex 
            titles.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath],
                                             withRowAnimation: .Automatic)
        }
    }
    

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
