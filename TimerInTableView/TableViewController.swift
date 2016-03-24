//
//  TableViewController.swift
//  TimerInTableView
//
//  Created by Daniel on 24.03.16.
//  Copyright © 2016 myknack. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    let debug = true
    
    // MARK: - Properties
    var timer:NSTimer?
    var timerIsRunning:Bool = false
    let startTime:NSDate = NSDate()
    let shouldRun = true
    
    // Const
    let timerDelta = 0.04
    
    // Dummy
    var data = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.startTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data
    }

  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        cell.textLabel!.text = "\(self.calcAccumulatedTimeAsString())"
        return cell
    }
    
    // MARK: - Delete actions
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if debug {
            Debug.logFunction()
        }
        if editing {
            self.stopTimer()
        } else {
            
            // TODO: Error occur
            /*
            Error occurs if  swipe to delete gesture is canceled
            Info: get called twice .... (check if you uncoment the check function) - tableview.reloadData is necessary
            Message: reloading table view while we're in swipe to delete mode but we don't have a proper swipe to delete index path
            */
            print("Error")
            self.checkState()
            
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            self.data--
            self.tableView.beginUpdates()
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            self.tableView.endUpdates()
            self.checkState()
        }
    }
    
    // Change color of delete button
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .Default, title: "Delete", handler: { (action, indexPath) in
            self.tableView.dataSource?.tableView?(
                self.tableView,
                commitEditingStyle: .Delete,
                forRowAtIndexPath: indexPath
            )
            
            return
        })
        
        deleteButton.backgroundColor = UIColor.redColor()
        return [deleteButton]
    }

    
    // Timer
    private func startTimer() {
        if debug {
            Debug.logFunction()
            print("Activate timer with interval \(timerDelta)!")
        }
        self.timerIsRunning = true
        self.timer = NSTimer.scheduledTimerWithTimeInterval(timerDelta, target: self, selector: Selector("timerUpdate:"), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        if debug {
            Debug.logFunction()
        }
        if let timer = self.timer {
            if debug {
                print("Deactivate timer!")
            }
            timer.invalidate()
            self.timer = nil
            self.timerIsRunning = false
        }
    }
    
    
    func timerUpdate(timer: NSTimer) {
        if debug {
            print("Timer is running ...")
        }
        if self.timerIsRunning {
            self.tableView.reloadData()
        } else {
            timer.invalidate()
            self.timer = nil
        }
    }
    
    func checkState() {
        if debug {
            Debug.logFunction()
        }
        
        if self.shouldRun { // will be more complicated in the other case :)
            self.startTimer()
        } else {
            self.stopTimer()
            
        }
        
        self.tableView.reloadData()
        
    }
    
    // Helper
    
    func calcAccumulatedTimeAsString() -> String {
        if debug {
            Debug.logFunction()
        }
        
        var accumulatedTime = NSTimeInterval()
        
        let now:NSDate = NSDate()
        accumulatedTime = now.timeIntervalSinceDate(startTime)
        let timerDate:NSDate = NSDate(timeIntervalSince1970: accumulatedTime)
        
        // Create a date formatter
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("mm:ss.SS")
        let timeZone = NSTimeZone(forSecondsFromGMT: 0)
        dateFormatter.timeZone = timeZone
        
        // Format the elapsed time and set it to the label
        let timeString = dateFormatter.stringFromDate(timerDate)
        
        return timeString
    }
    
    


}
