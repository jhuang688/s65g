//
//  StandardEngine.swift
//  Assignment4
//
//  Created by Joanne Huang on 11/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

import Foundation

class StandardEngine: EngineProtocol {
    private static var _sharedInstance = StandardEngine(cols: 10, rows: 10)
    static var sharedInstance: StandardEngine {
        get {
            return _sharedInstance
        }
    }
    
    required init(cols: Int, rows: Int) {
        self.cols = cols
        self.rows = rows
        grid = Grid(cols: cols, rows: rows)
        
    }

    var rows: Int {
        didSet {
            grid = Grid(cols: cols, rows: rows)
            for col in 0..<cols {
                for row in 0..<rows {
                    grid![col,row] = .Empty
                }
            }
            
            // PROBLEM HERE: DELEGATE IS NOT YET SET, GETTING NIL ON UNWRAP GRID
            if let delegate = delegate {
                delegate.engineDidUpdate(grid! as! Grid)
            }
        }
    }

    var cols: Int {
        didSet {
            grid = Grid(cols: cols, rows: rows)
            for col in 0..<cols {
                for row in 0..<rows {
                    grid![col,row] = .Empty
                }
            }
            
            // PROBLEM HERE: DELEGATE IS NOT YET SET  GETTING NIL ON  UNWRAP
            if let delegate = delegate {
                delegate.engineDidUpdate(grid! as! Grid)
            }
        }
    }

    var delegate: EngineDelegateProtocol?
    var grid: GridProtocol?
    
    var refreshRate: Double = 0.0 {
        didSet {
            if refreshRate != 0 {
                if let refreshTimer = refreshTimer { refreshTimer.invalidate() }
                let sel = #selector(StandardEngine.timerDidFire(_:))
                refreshTimer = NSTimer.scheduledTimerWithTimeInterval(refreshRate,
                                                               target: self,
                                                               selector: sel,
                                                               userInfo: nil,
                                                               repeats: true)
            }
            else if let refreshTimer = refreshTimer {   // it should never be 0 since slider doesn't go to 0, but
                                                        // in case it does one day, leave the logic here
                refreshTimer.invalidate()
                self.refreshTimer = nil
            }
        }
    }

    var refreshTimer: NSTimer? //= nil // by default, the timer is off

    func step() -> GridProtocol {
        var after: GridProtocol? = grid
        
        // check neighbours' states and update count of living neighbours
        for col in 0..<cols{
            for row in 0..<rows{
                var livingNeighbours = 0  // stores count of living neighbours
                // get the list of neighbours
                let neighboursList: [(Int, Int)] = grid!.neighbours((col, row: row), maxCol: cols, maxRow: rows)
                // for each tuple returned from neighbours, check status and update count
                for (column, row) in neighboursList {
                    if grid![column,row] == .Living || grid![column,row] == .Born {
                        livingNeighbours += 1
                    }
                }
                
                // update after array accordingly
                switch livingNeighbours {
                case 2:   // 2 living neighbours - stay living or stay dead
                    if grid![col,row] == .Living || grid![col,row] == .Born {
                        after![col,row] = .Living
                    }
                    else {
                        after![col,row] = .Empty
                    }
                case 3:   // 3 living neighbours - stay living or be born
                    if grid![col,row] == .Living || grid![col,row] == .Born {
                        after![col,row] = .Living
                    }
                    else {
                        after![col,row] = .Born
                    }
                default:   // all others - die or stay dead
                    if grid![col,row] == .Living || grid![col,row] == .Born {
                        after![col,row] = .Died
                    }
                    else {
                        after![col,row] = .Empty
                    }
                }
            }
        }
        
        return after!
    }

    @objc func timerDidFire(timer:NSTimer) {
        let center = NSNotificationCenter.defaultCenter()
        let n = NSNotification(name: "TimerFired",
                               object: nil,
                               userInfo: nil)
                               //userInfo: ["gridObject": grid! as! AnyObject])
        center.postNotification(n)
    }
}