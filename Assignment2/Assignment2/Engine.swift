//
//  Engine.swift
//  Assignment2
//
//  Created by Joanne Huang on 30/06/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

import Foundation

func step (beforeArray before: Array<Array<Bool>>) -> Array<Array<Bool>> {

    var after: [[Bool]] = []
    
    let columns = before.count
    let rows = before[0].count
    
    // initialise after
    for _ in 0..<columns {
        after.append(Array(count:rows, repeatedValue:false))
    }
    
    // check neighbours and update after
    for col in 0..<columns{
        var prevCol = col - 1
        var nextCol = col + 1
        // handle wrapping rules
        if prevCol < 0 {
            prevCol = columns - 1
        }
        if nextCol > columns - 1 {
            nextCol = 0
        }
        
        for row in 0..<rows{
            var prevRow = row - 1
            var nextRow = row + 1
            // handle wrapping rules
            if prevRow < 0 {
                prevRow = rows - 1
            }
            if nextRow > rows - 1 {
                nextRow = 0
            }
            
            // check neighbours and update count
            var livingNeighbours = 0
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
            
            // update after accordingly
            switch livingNeighbours {
            case 2:   // 2 living neighbours - check current status
                if before[col][row] == true {
                    after[col][row] = true
                }
                else {
                    after[col][row] = false
                }
            case 3:
                after[col][row] = true
            default:
                after[col][row] = false
            }
        }
    }
    
    return after
}

func step2 (beforeArray before: Array<Array<Bool>>) -> Array<Array<Bool>> {
    
    var after: [[Bool]] = []
    
    let columns = before.count
    let rows = before[0].count
    
    // initialise after
    for _ in 0..<columns {
        after.append(Array(count:rows, repeatedValue:false))
    }
    
    // check neighbours and update after
    for col in 0..<columns{
        for row in 0..<rows{
            // check neighbours and update count
            var livingNeighbours = 0
            // for each tuple returned from neighbours, count alive
            let neighboursList: [(Int, Int)] = neighbours((col, row: row), maxCol: columns, maxRow: rows)
            for (column, row) in neighboursList {
                if before[column][row] == true {
                    livingNeighbours += 1
                }
            }
            
            // update after accordingly
            switch livingNeighbours {
            case 2:   // 2 living neighbours - check current status
                if before[col][row] == true {
                    after[col][row] = true
                }
                else {
                    after[col][row] = false
                }
            case 3:
                after[col][row] = true
            default:
                after[col][row] = false
            }
        }
    }
    
    return after
}


func neighbours(coords: (col: Int, row: Int), maxCol: Int, maxRow: Int) -> Array<(Int, Int)> {
    
    var prevCol = coords.col - 1
    var nextCol = coords.col + 1
    var prevRow = coords.row - 1
    var nextRow = coords.row + 1
    
    
    // SHOULD GET THESE VALUES FROM SOMEWHERE
    //let rows = 10
    //let columns = 10
    
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