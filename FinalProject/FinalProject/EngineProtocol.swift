//
//  EngineProtocol.swift
//  FinalProject
//
//  Created by Joanne Huang on 11/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

import Foundation

protocol EngineProtocol {
    init(rows: Int, cols: Int, cellInitializer: CellInitializer)
    
    var delegate: EngineDelegateProtocol? {get set}
    var grid: GridProtocol {get}
    var refreshRate: Double {get set} //= 0.0
    var refreshTimer: NSTimer? {get set}
    var rows: Int { get set }
    var cols: Int { get set }
    
    func step() -> GridProtocol
}