//
//  Grid.swift
//  FinalProject
//
//  Created by Joanne Huang on 14/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

//func blah() -> CellState

typealias CellInitializer = () -> CellState

struct Grid : GridProtocol {
    var rows: Int
    var cols: Int
    var cells: [Cell]
//    var points: [Position]? {
//        didSet {
//            let array: [Int] = points!.map { $0.row * cols + $0.col }
//            for i in 0..<rows*cols {
//                if array.contains(i) {
//                    cells[i].state = .Living
//                }
//                else {
//                    cells[i].state = .Empty
//                }
//            } //cells = (0..<rows*cols).map {
//                
//            //}
//        }
//    }
    
    var alive: Int { return cells.reduce(0) { return  $1.state.isAlive() ?  $0 + 1 : $0 } }
    var dead:   Int { return cells.reduce(0) { return !$1.state.isAlive() ?  $0 + 1 : $0 } }
    var living:  Int { return cells.reduce(0) { return  $1.state == .Living  ?  $0 + 1 : $0 } }
    var born:   Int { return cells.reduce(0) { return  $1.state == .Born   ?  $0 + 1 : $0 } }
    var died:   Int { return cells.reduce(0) { return  $1.state == .Died   ?  $0 + 1 : $0 } }
    var empty:  Int { return cells.reduce(0) { return  $1.state == .Empty  ?  $0 + 1 : $0 } }
    var diseased:  Int { return cells.reduce(0) { return  $1.state == .Diseased  ?  $0 + 1 : $0 } }
    
    init (rows: Int, cols: Int, cellInitializer: CellInitializer) {
        self.rows = rows
        self.cols = cols
        self.cells = (0..<rows*cols).map {
            Cell(Position($0/cols, $0%cols), cellInitializer())
        }
    }
    
    static let offsets:[Position] = [
        Position(-1, -1), Position(-1, 0), Position(-1, 1),
        Position( 0, -1),                  Position( 0, 1),
        Position( 1, -1), Position( 1, 0), Position( 1, 1)
    ]
    func neighbors(pos: Position) -> [Position] {
        return Grid.offsets.map { Position((pos.row + rows + $0.row) % rows,
            (pos.col + cols + $0.col) % cols) }
    }
    
    func livingNeighbors(cell: Cell) -> Int {
        return self.neighbors(Position(cell.position.row, cell.position.col))
            .reduce(0) { cells[$1.row*cols + $1.col].state.isAlive() ? $0 + 1 : $0 }
    }
    
//    func step() -> Grid {
//        var newGrid = Grid(self.rows, self.cols) { .Empty }
//        newGrid.cells = cells.map {
//            switch self.livingNeighbors($0) {
//            case 2 where $0.state.isAlive(),
//            3 where $0.state.isAlive():  return Cell($0.position, .Living)
//            case 3 where !$0.state.isAlive(): return Cell($0.position, .Born)
//            case _ where $0.state.isAlive():  return Cell($0.position, .Died)
//            default:                           return Cell($0.position, .Empty)
//            }
//        }
//        return newGrid
//    }
    
    // used to get and set cells, given col and row
//    subscript(row: Int, col: Int) -> CellState? {
//        get {
//            if row < 0 || row >= rows || col < 0 || col >= cols {
//                return nil
//            }
//            
//            // CHECK THIS?
//            return cells[row * cols + col].state
//        }
//        set (newValue) {
//            if newValue == nil { return }
//            if row < 0 || row >= rows || col < 0 || col >= cols { return }
//            
//            // CHECK THIS?
//            cells[row * cols + col].state = newValue!
//        }
//    }
    
    subscript(row: Int, col: Int) -> Cell? {
        get {
            if row < 0 || row >= rows || col < 0 || col >= cols {
                return nil
            }
            return cells[row * cols + col] //.state
        }
        set (newValue) {
            if newValue == nil { return }
            if row < 0 || row >= rows || col < 0 || col >= cols { return }
            cells[row * cols + col] = newValue!
        }
    }
}


//class Grid: GridProtocol {
//    required init(cols: Int, rows: Int) {
//        self.rows = rows
//        self.cols = cols
//        // initialise as all empty
//        for _ in 0..<cols {
//            cells.append(Array(count:rows, repeatedValue:.Empty))
//        }
//    }
    
//    var rows: Int
//    var cols: Int
    
    // returns the neighbours of a cell as an array of tuples
//    func neighbours(coords: (col: Int, row: Int), maxCol: Int, maxRow: Int) -> Array<(Int, Int)> {
//        var prevCol = coords.col - 1   // index of previous col
//        var nextCol = coords.col + 1   // index of next col
//        var prevRow = coords.row - 1   // index of previous row
//        var nextRow = coords.row + 1   // index of next row
//        
//        // handle wrapping rules
//        if prevCol < 0 {
//            prevCol = maxCol - 1
//        }
//        if nextCol > maxCol - 1 {
//            nextCol = 0
//        }
//        
//        // handle wrapping rules
//        if prevRow < 0 {
//            prevRow = maxRow - 1
//        }
//        if nextRow > maxRow - 1 {
//            nextRow = 0
//        }
//        
//        return [(prevCol, prevRow), (prevCol, coords.row), (prevCol, nextRow),
//                (coords.col, prevRow), (coords.col, nextRow),
//                (nextCol, prevRow), (nextCol, coords.row), (nextCol, nextRow)]
//    }
    
    // 2D array of cell states representing the grid
//    private var cells : [[CellState]] =  []

//    // used to get and set cells, given col and row
//    subscript(col: Int, row: Int) -> CellState? {
//        get {
//            if row < 0 || row >= rows || col < 0 || col >= cols {
//                return nil
//            }
//            return cells[col][row]
//        }
//        set (newValue) {
//            if newValue == nil { return }
//            if row < 0 || row >= rows || col < 0 || col >= cols { return }
//            cells[col][row] = newValue!
//        }
//    }
//}