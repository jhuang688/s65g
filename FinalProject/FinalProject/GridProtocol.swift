//
//  GridProtocol.swift
//  FinalProject
//
//  Created by Joanne Huang on 11/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//


protocol GridProtocol {
    init(cols: Int, rows: Int)
    var rows: Int { get }
    var cols: Int { get }
    
    func neighbours(coords: (col: Int, row: Int), maxCol: Int, maxRow: Int) -> Array<(Int, Int)>
    
    subscript(col: Int, row: Int) -> CellState? { get set }
}

