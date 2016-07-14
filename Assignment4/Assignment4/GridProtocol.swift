//
//  GridProtocol.swift
//  Assignment4
//
//  Created by Joanne Huang on 11/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//


protocol GridProtocol {
    init(cols: Int, rows: Int)
    var rows: Int { get }
    var cols: Int { get }
    
    func neighbours(coords: (col: Int, row: Int), maxCol: Int, maxRow: Int) -> Array<(Int, Int)>
    
    subscript(row: Int, col: Int) -> CellState? { get set }
}

class Grid: GridProtocol {
    required init(cols: Int, rows: Int) {
        self.rows = rows
        self.cols = cols
    }
    
    var rows: Int
    var cols: Int
    
    func neighbours(coords: (col: Int, row: Int), maxCol: Int, maxRow: Int) -> Array<(Int, Int)> {
        var prevCol = coords.col - 1   // index of previous col
        var nextCol = coords.col + 1   // index of next col
        var prevRow = coords.row - 1   // index of previous row
        var nextRow = coords.row + 1   // index of next row
        
        // handle wrapping rules
        if prevCol < 0 {
            prevCol = maxCol - 1
        }
        if nextCol > maxCol - 1 {
            nextCol = 0
        }
        
        // handle wrapping rules
        if prevRow < 0 {
            prevRow = maxRow - 1
        }
        if nextRow > maxRow - 1 {
            nextRow = 0
        }
        
        return [(prevCol, prevRow), (prevCol, coords.row), (prevCol, nextRow),
                (coords.col, prevRow), (coords.col, nextRow),
                (nextCol, prevRow), (nextCol, coords.row), (nextCol, nextRow)]
    }
    
    private var cells : [[CellState]] =  []
//    for _ in 0..<cols {
//        cells.append(Array(count:rows, repeatedValue:.Empty))
//    }
    subscript(row: Int, col: Int) -> CellState? {
        get {
            if row < 0 || row >= rows || col < 0 || col >= cols {
                return nil
            }
            return cells[col][row]
        }
        set (newValue) {
            if newValue == nil { return }
            if row < 0 || row >= rows || col < 0 || col >= cols { return }
            cells[col][row] = newValue!
        }
    }
    
//    subscript(row: Int, col: Int) -> CellState {
//        get {
//            //assert(indexIsValidForRow(row, column: column), "Index out of range")
//            //return grid[(row * self.cols) + col]
//            //return grid[col][row]
//            return CellState.Empty //grid[col][row]
//        }
//        set {
//            //assert(indexIsValidForRow(row, column: column), "Index out of range")
//            //grid[(row * columns) + column] = newValue
//            //grid[col][row] = newValue
//            
//        }
//    }
}