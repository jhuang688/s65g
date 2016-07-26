//
//  GridProtocol.swift
//  FinalProject
//
//  Created by Joanne Huang on 11/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//


protocol GridProtocol {
    init(rows: Int, cols: Int, cellInitializer: CellInitializer)
    var rows: Int { get }
    var cols: Int { get }
    var cells: [Cell] { get set }
//    var points: [Position]? { get set }
    
    //func neighbours(coords: (col: Int, row: Int), maxCol: Int, maxRow: Int) -> Array<(Int, Int)>
    func neighbors(pos: Position) -> [Position]
    func livingNeighbors(pos: Position) -> Int
    
    subscript(row: Int, col: Int) -> CellState { get set }
    //subscript(row: Int, col: Int) -> CellState? { get set }
    
    var alive: Int { get }
    var dead: Int { get }
    var living: Int { get }
    var born: Int { get }
    var died: Int { get }
    var empty: Int { get }
    var diseased: Int { get }
}

