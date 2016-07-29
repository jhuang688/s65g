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
                        print(message)
                        self.presentAlert(message)
                        //self.fetchError(message)
                    }
                    else {
                        //self.fetchError("An error has occurred.")
                    }
                }
            } catch {
                //fetchError("Invalid URL")
            }
        }
    }

    @IBOutlet weak var addButton: UIBarButtonItem!
    
    enum Errors : ErrorType {
        case InvalidURL
    }
    
    func makeURL(urlString: String) throws -> NSURL? {
        let url = NSURL(string: urlString)
        if ((url) == nil) {
            throw Errors.InvalidURL
        }
        return url
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set default url. Loads on app launch.
        urlString = "https://dl.dropboxusercontent.com/u/7544475/S65g.json"

        // subscribe to SaveConfig notifications
        let sel = #selector(ConfigurationViewController.watchForNotifications(_:))
        let center  = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: sel, name: "SaveConfig", object: nil)

        // subscribe to ReloadURL notifications
        let sel2 = #selector(ConfigurationViewController.setURLString(_:))
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
    
    override func viewDidAppear(animated: Bool) {
        
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        guard let editingVC = segue.destinationViewController as? ConfigurationEditorViewController
            else {
                preconditionFailure("There has been an error")
        }
        if segue.identifier == "newConfig" {
            editingVC.navigationItem.title = "New Configuration"
        }
        else {
            let editingRow: Int = (sender as! UITableViewCell).tag
            let editingString: String = titles[editingRow]
            
            editingVC.nameString = editingString
            
            positions = []
            for i in 0..<(configs[editingRow]["contents"]!.count) {
                positions.append(Position((configs[editingRow]["contents"]![i] as! Array)[0], (configs[editingRow]["contents"]![i] as! Array)[1]))
            }
//            positions = configs[editingRow]["contents"].map {
//                return Position(Int($0 as! NSNumber)/20, Int($0 as! NSNumber)%20)     // HARDCODED FOR NOW TO 20/20
//            }!
            editingVC.pointsArray = positions
            
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("Default")
            else {
                preconditionFailure("missing Default reuse identifier")
        }
        let row = indexPath.row
        guard let nameLabel = cell.textLabel else {
            preconditionFailure("There has been an error")
        }
        nameLabel.text = titles[row]
        cell.tag = row
        return cell
    }
    
    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                                               forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
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

    
    // sends FetchError notifications
    @objc func fetchError(text : String) {
        let center = NSNotificationCenter.defaultCenter()
        let n = NSNotification(name: "FetchError",
                               object: nil,
                               userInfo: ["message":text])
        center.postNotification(n)
    }
    
    func presentAlert(text: String) {
        let refreshAlert = UIAlertController(title: "Could not fetch data", message: text, preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            // Handle "Ok" logic here (do nothing)
        }))
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.presentViewController(refreshAlert, animated: true, completion: nil)
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
