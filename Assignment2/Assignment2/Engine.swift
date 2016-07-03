//
//  Engine.swift
//  Assignment2
//
//  Created by Joanne Huang on 30/06/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

import Foundation

// This function takes a before array and returns an after array
// according to the rules of Conway's Game of Life.
// The arrays are 2D arrays of bools of the same size
// It is used by Problem 3
func step (beforeArray before: Array<Array<Bool>>) -> Array<Array<Bool>> {

    var after: [[Bool]] = []   // after array to be returned
    
    let columns = before.count   // number of cols same as before
    let rows = before[0].count   // number of rows same as before
    
    // initialise after array to all false
    for _ in 0..<columns {
        after.append(Array(count:rows, repeatedValue:false))
    }
    
    // check neighbours and update after array
    for col in 0..<columns{
        var prevCol = col - 1   // index of previous col
        var nextCol = col + 1   // index of next col
        // handle wrapping rules
        if prevCol < 0 {
            prevCol = columns - 1
        }
        if nextCol > columns - 1 {
            nextCol = 0
        }
        
        for row in 0..<rows{
            var prevRow = row - 1   // index of previous row
            var nextRow = row + 1   // index of next row
            // handle wrapping rules
            if prevRow < 0 {
                prevRow = rows - 1
            }
            if nextRow > rows - 1 {
                nextRow = 0
            }
            
            // check neighbours' states and update count
            var livingNeighbours = 0   // num living neighbours
            if before[prevCol][prevRow] == true {
                livingNeighbours += 1
            }
            if before[prevCol][row] == true {
                livingNeighbours += 1
            }
            if before[prevCol][nextRow] == true {
                livingNeighbours += 1
            }
            if before[col][prevRow] == true {
                livingNeighbours += 1
            }
            if before[col][nextRow] == true {
                livingNeighbours += 1
            }
            if before[nextCol][prevRow] == true {
                livingNeighbours += 1
            }
            if before[nextCol][row] == true {
                livingNeighbours += 1
            }
            if before[nextCol][nextRow] == true {
                livingNeighbours += 1
            }
            
            // update after array accordingly
            switch livingNeighbours {
            case 2:   // 2 living neighbours - check current status
                if before[col][row] == true {
                    after[col][row] = true
                }
                else {
                    after[col][row] = false
                }
            case 3:  // 3 living neighbours - born or stay alive
                after[col][row] = true
            default:  // all others - die or stay dead
                after[col][row] = false
            }
        }
    }
    
    return after
}

// This function takes a before array and returns an after array
// according to the rules of Conway's Game of Life.
// The arrays are 2D arrays of bools of the same size
// It invokes neighbours() to find the neighbours according to
// wrapping rules.
// It is used by Problem 4
func step2 (beforeArray before: Array<Array<Bool>>) -> Array<Array<Bool>> {
    
    var after: [[Bool]] = []   // after array to be returned
    
    let columns = before.count   // number of cols same as before
    let rows = before[0].count   // number of rows same as before
    
    // initialise after to all false
    for _ in 0..<columns {
        after.append(Array(count:rows, repeatedValue:false))
    }
    
    // check neighbours' states and update count and after
    for col in 0..<columns{
        for row in 0..<rows{
            var livingNeighbours = 0  // num living neighbours
            // get the list of neighbours using the function
            let neighboursList: [(Int, Int)] = neighbours((col, row: row), maxCol: columns, maxRow: rows)
            // for each tuple returned from neighbours, check status and update count
            for (column, row) in neighboursList {
                if before[column][row] == true {
                    livingNeighbours += 1
                }
            }
            
            // update after array accordingly
            switch livingNeighbours {
            case 2:   // 2 living neighbours - check current status
                if before[col][row] == true {
                    after[col][row] = true
                }
                else {
                    after[col][row] = false
                }
            case 3:   // 3 living neighbours - born or stay alive
                after[col][row] = true
            default:   // all others - die or stay dead
                after[col][row] = false
            }
        }
    }
    
    return after
}

// This function takes a co-ordinate from the before array as a tuple,
// the max number of cols and rows, and returns an array of tuples
// representing the 8 different neighbours according to wrapping rules.
// It is used by Problem 4, invoked by step2
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