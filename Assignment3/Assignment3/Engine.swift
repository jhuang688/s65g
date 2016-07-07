//
//  Engine.swift
//  Assignment3
//
//  Created by Joanne Huang on 7/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

import Foundation

// This function takes a before array and returns an after array
// according to the rules of Conway's Game of Life.
// The arrays are 2D arrays of CellState of the same size
// It invokes neighbours() to find the neighbours according to
// wrapping rules.
func step2 (beforeArray before: Array<Array<CellState>>) -> Array<Array<CellState>> {
    
    var after: [[CellState]] = []   // after array to be returned
    
    let columns = before.count   // number of cols same as before
    let rows = before[0].count   // number of rows same as before
    
    // initialise after to all empty
    for _ in 0..<columns {
        after.append(Array(count:rows, repeatedValue:.Empty))
    }
    
    // check neighbours' states and update count of living neighbours
    for col in 0..<columns{
        for row in 0..<rows{
            var livingNeighbours = 0  // num living neighbours
            // get the list of neighbours using the function
            let neighboursList: [(Int, Int)] = neighbours((col, row: row), maxCol: columns, maxRow: rows)
            // for each tuple returned from neighbours, check status and update count
            for (column, row) in neighboursList {
                if before[column][row] == .Living || before[column][row] == .Born {
                    livingNeighbours += 1
                }
            }
            
            // update after array accordingly
            switch livingNeighbours {
            case 2:   // 2 living neighbours - stay living or stay dead
                if before[col][row] == .Living || before[col][row] == .Born {
                    after[col][row] = .Living
                }
                else {
                    after[col][row] = .Empty
                }
            case 3:   // 3 living neighbours - stay living or be born
                if before[col][row] == .Living || before[col][row] == .Born {
                    after[col][row] = .Living
                }
                else {
                    after[col][row] = .Born
                }
            default:   // all others - die or stay dead
                if before[col][row] == .Living || before[col][row] == .Born {
                    after[col][row] = .Died
                }
                else {
                    after[col][row] = .Empty
                }
            }
        }
    }
    
    return after
}

// This function takes a co-ordinate from the before array as a tuple,
// the max number of cols and rows, and returns an array of tuples
// representing the 8 different neighbours according to wrapping rules.
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