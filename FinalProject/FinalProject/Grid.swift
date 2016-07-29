//
//  Grid.swift
//  FinalProject
//
//  Created by Joanne Huang on 14/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

typealias CellInitializer = (Position) -> CellState

struct Grid : GridProtocol {
    private(set) var rows: Int
    private(set) var cols: Int
    var cells: [Cell]
    var title: String?
    
    var alive: Int { return cells.reduce(0) { return  $1.state.isAlive() ?  $0 + 1 : $0 } }
    var dead:   Int { return cells.reduce(0) { return !$1.state.isAlive() ?  $0 + 1 : $0 } }
    var living:  Int { return cells.reduce(0) { return  $1.state == .Living  ?  $0 + 1 : $0 } }
    var born:   Int { return cells.reduce(0) { return  $1.state == .Born   ?  $0 + 1 : $0 } }
    var died:   Int { return cells.reduce(0) { return  $1.state == .Died   ?  $0 + 1 : $0 } }
    var empty:  Int { return cells.reduce(0) { return  $1.state == .Empty  ?  $0 + 1 : $0 } }
    var diseased:  Int { return cells.reduce(0) { return  $1.state == .Diseased  ?  $0 + 1 : $0 } }
    
    init (rows: Int, cols: Int, cellInitializer: CellInitializer = {_ in .Empty }) {
        self.rows = rows
        self.cols = cols
        self.cells = (0..<rows*cols).map {
            let pos = Position($0/cols, $0%cols)
            return Cell(pos, cellInitializer(pos))
        }
    }
    
    private static let offsets:[Position] = [
        Position(-1, -1), Position(-1, 0), Position(-1, 1),
        Position( 0, -1),                  Position( 0, 1),
        Position( 1, -1), Position( 1, 0), Position( 1, 1)
    ]
    func neighbors(pos: Position) -> [Position] {
        return Grid.offsets.map { Position((pos.row + rows + $0.row) % rows,
            (pos.col + cols + $0.col) % cols) }
    }
    
    func livingNeighbors(pos: Position) -> Int {
        return neighbors(pos)
            .reduce(0) { self[$1.row,$1.col]!.isAlive() ? $0 + 1 : $0 }
    }
    
    subscript(row: Int, col: Int) -> CellState? {
        get {
            if row < 0 || row >= rows || col < 0 || col >= cols {
                return nil
            }
            return cells[row * cols + col].state
        }
        set (newValue) {
            if newValue == nil { return }
            if row < 0 || row >= rows || col < 0 || col >= cols { return }
            cells[row * cols + col].state = newValue!
        }
    }
}