//
//  StandardEngine.swift
//  FinalProject
//
//  Created by Joanne Huang on 11/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

import Foundation

class StandardEngine: EngineProtocol {
    // singleton
    private static var _sharedInstance = StandardEngine(rows: 20, cols: 20)
    static var sharedInstance: StandardEngine {
        get {
            return _sharedInstance
        }
    }
    
//    required init(rows: Int, cols: Int) {
//        self.cols = cols
//        self.rows = rows
//        //refreshRate = 0.0    // set default refreshRate
////        grid = Grid(rows, cols, cellInitializer: CellInitializer)
//        grid = Grid(rows: rows, cols: cols) {_ in 
//            .Empty
//        }
//        
//    }
    
    required init(rows: Int, cols: Int, cellInitializer: CellInitializer = {_ in .Empty }) {   // default value if nothing given
        self.rows = rows
        self.cols = cols
        self.grid = Grid(rows: rows,cols: cols, cellInitializer: cellInitializer)
    }
    
    var rows: Int {
        didSet {
            // re-initialise grid
            grid = Grid(rows: rows, cols: cols) { _ in
                .Empty
            }
            
            // TESTING AREA:
//            grid!.points = [Position(1, 3), Position(3, 5)]
            
            
            
            // send EngineUpdate notification
            if let delegate = delegate {
                delegate.engineDidUpdate(grid)
            }
        }
    }
    
    var cols: Int {
        didSet {
            // re-initialise grid
            grid = Grid(rows: rows, cols: cols) { _ in
                .Empty
            }

            // send EngineUpdate notification
            if let delegate = delegate {
                delegate.engineDidUpdate(grid)
            }
        }
    }
    
    weak var delegate: EngineDelegateProtocol?
    var grid: GridProtocol
    
    var refreshRate: Double = 0.0 {
        didSet {
            if refreshRate != 0 {   // remove existing timer if necessary and install new one
                if let refreshTimer = refreshTimer {
                    refreshTimer.invalidate()
                    self.refreshTimer = nil
                }
                let sel = #selector(StandardEngine.timerDidFire(_:))
                
                refreshTimer = NSTimer.scheduledTimerWithTimeInterval(refreshRate,
                                                                      target: self,
                                                                      selector: sel,
                                                                      userInfo: nil,
                                                                      repeats: true)
            }
            else if let refreshTimer = refreshTimer {   // refreshRate = 0 -> remove existing timer
                refreshTimer.invalidate()
                self.refreshTimer = nil
            }
        }
    }
    
    var refreshTimer: NSTimer?   // by default, the timer is off, and refreshRate is 0.0
    
    subscript (row:Int, col:Int) -> CellState {
        get {
            return grid.cells[row*cols+col].state
        }
        set {
            grid.cells[row*cols+col].state = newValue
        }
    }
    
//    func step() -> GridProtocol {
//        var after: GridProtocol? = grid
//        
//        // check neighbours' states and update count of living neighbours
//        for col in 0..<cols{
//            for row in 0..<rows{
//                var livingNeighbours = 0  // stores count of living neighbours
//                // get the list of neighbours
//                let neighboursList: [Position] = grid!.neighbors(Position(row, col))
//                // for each tuple returned from neighbours, check status and update count
//                for (column, row) in neighboursList {
//                    if grid![column,row] == .Living || grid![column,row] == .Born {
//                        livingNeighbours += 1
//                    }
//                }
//                
//                // update after array accordingly
//                switch livingNeighbours {
//                case 2:   // 2 living neighbours - stay living or stay dead
//                    if grid![col,row] == .Living || grid![col,row] == .Born {
//                        after![col,row] = .Living
//                    }
//                    else {
//                        after![col,row] = .Empty
//                    }
//                case 3:   // 3 living neighbours - stay living or be born
//                    if grid![col,row] == .Living || grid![col,row] == .Born {
//                        after![col,row] = .Living
//                    }
//                    else {
//                        after![col,row] = .Born
//                    }
//                default:   // all others - die or stay dead
//                    if grid![col,row] == .Living || grid![col,row] == .Born {
//                        after![col,row] = .Died
//                    }
//                    else {
//                        after![col,row] = .Empty
//                    }
//                }
//            }
//        }
//        
//        return after!
//    }
    
    
    func step() -> GridProtocol {
        var newGrid = Grid(rows: grid.rows, cols: grid.cols) { _ in .Empty }
        newGrid.cells = grid.cells.map {
            if $0.state == .Diseased {    // diseased cells will stay diseased
                return Cell($0.position, .Diseased)
            }
            else if $0.state.isAlive() && hasDiseasedNeighbor($0.position) {   // living neighbours of diseased cells become diseased
                return Cell($0.position, .Diseased)
            }
            else {        // all other cells are treated as usual
                switch grid.livingNeighbors($0.position) {
                case 2 where $0.state.isAlive(),
                3 where $0.state.isAlive():  return Cell($0.position, .Living)
                case 3 where !$0.state.isAlive(): return Cell($0.position, .Born)
                case _ where $0.state.isAlive():  return Cell($0.position, .Died)
                default:                           return Cell($0.position, .Empty)
                }

            }
        }
        return newGrid
    }
    
    func hasDiseasedNeighbor (pos: Position) -> Bool {
        let neighborArray = grid.neighbors(pos)
        for i in 0..<neighborArray.count {
            if grid[neighborArray[i].row, neighborArray[i].col] == .Diseased {
                return true
            }
        }
        return false
    }
    
    // TimerFired notifications are sent by the timer
    @objc func timerDidFire(timer:NSTimer) {
        let center = NSNotificationCenter.defaultCenter()
        let n = NSNotification(name: "TimerFired",
                               object: nil,
                               userInfo: nil)
//                               userInfo: ["gridObject": StandardEngine.sharedInstance.grid! as! AnyObject])
        center.postNotification(n)
    }
}
