//
//  ConfigurationViewController.swift
//  FinalProject
//
//  Created by Joanne Huang on 26/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

import UIKit

class ConfigurationViewController: UITableViewController {
    
    var configs: Array<Dictionary<String,AnyObject>> = []
    var titles: Array<String> = []
    var positions: Array<Position> = []
    
    var urlString: String? {
        didSet {

            let url: NSURL?

            do {
                try url = makeURL(urlString!) //url = NSURL(string: urlString!)
                let fetcher = Fetcher()
                fetcher.requestJSON(url!) { (json, message) in
                    if let json = json,
                        topArray = json as? Array<Dictionary<String,AnyObject>> {
                        // clear existing
                        self.configs = []
                        self.titles = []
                        
                        self.configs = topArray
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
                        self.presentAlert(message)
                        //self.rows.text = message
                    }
                    else {
                        // handle errors here - ALERT PANEL!
                        self.presentAlert("An error has occurred.")
                        //print("wtf")
                        //self.rows.text = "WTF?"
                    }
                }
            } catch {
                presentAlert("Invalid URL")
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
    
    func makeURL(urlString: String) throws -> NSURL? {
        let url = NSURL(string: urlString)
        if url == nil {
            throw Errors.InvalidURL
        }
        return url
    }
    
//    struct IncorrectURL : ErrorType {
//        let _domain: String = "Invalid URL"
//        let _code: Int = 1
//    }

    enum Errors : ErrorType {
        case InvalidURL
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set default string. Loads on app launch.
        urlString = "https://dl.dropboxusercontent.com/u/7544475/S65g.json"
        // urlString = "http://api.openweathermap.org/data/2.5/weather?q=boston,%20ma&appid=77e555f36584bc0c3d55e1e584960580"

        
        // subscribe to SaveConfig notifications
        let sel = #selector(ConfigurationViewController.watchForNotifications(_:))
        let center  = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: sel, name: "SaveConfig", object: nil)

        // subscribe to ReloadURL notifications
        let sel2 = #selector(ConfigurationViewController.setURLString(_:))
       // let center  = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: sel2, name: "ReloadURL", object: nil)
        
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
        
        self.tableView.reloadData()
        
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
            let editingRow: Int = (sender as! UITableViewCell).tag
            let editingString: String = titles[editingRow]
            
            editingVC.nameString = editingString //nameText.text = "\(editingString)"
            
            print(configs[editingRow]["contents"]!.count)
            positions = []
            for i in 0..<(configs[editingRow]["contents"]!.count) {
                positions.append(Position((configs[editingRow]["contents"]![i] as! Array)[0], (configs[editingRow]["contents"]![i] as! Array)[1]))
            }
//            positions = configs[editingRow]["contents"].map {
//                return Position(Int($0 as! NSNumber)/20, Int($0 as! NSNumber)%20)     // HARDCODED FOR NOW TO 20/20
//            }!
            editingVC.pointsArray = positions
            
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
            configs.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath],
                                             withRowAnimation: .Automatic)
            tableView.reloadData()
        }
    }
    
    func watchForNotifications(notification:NSNotification) {
        // add new config to table
        titles.append((notification.userInfo?["title"])! as! String)
        configs.append(notification.userInfo as! Dictionary<String,AnyObject>)
    }

    func setURLString(notification:NSNotification) {
        urlString = notification.userInfo?["url"] as? String
    }

    func presentAlert(text: String) {
        let refreshAlert = UIAlertController(title: "Could not fetch data", message: text, preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            //print("Handle Ok logic here")
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
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
