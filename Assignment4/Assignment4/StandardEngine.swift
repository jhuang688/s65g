//
//  StandardEngine.swift
//  Assignment4
//
//  Created by Joanne Huang on 11/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

import Foundation

class StandardEngine: EngineProtocol {
    required init(cols: Int, rows: Int) {
        self.cols = cols
        self.rows = rows
    }

    var rows: Int
    var cols: Int
    var delegate: EngineDelegate?
    var grid: GridProtocol?
    var refreshRate: Double = 0.0
    var refreshTimer: NSTimer = NSTimer()

    
    func step() -> GridProtocol {
       return grid!   // placeholder
    }
}
