//
//  Cell.swift
//  FinalProject
//
//  Created by Joanne Huang on 20/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

struct Cell {
    var position:Position
    var state:   CellState
    init( _ position: Position, _ state: CellState) {
        self.position = position
        self.state = state
    }
}