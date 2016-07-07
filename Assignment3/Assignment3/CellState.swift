//
//  CellState.swift
//  Assignment3
//
//  Created by Joanne Huang on 6/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

import Foundation

enum CellState : String {
    case Living = "living"
    case Empty = "empty"
    case Born = "born"
    case Died = "died"
    
    func description() -> String {
        return self.rawValue
    }
    
    static func allValues() -> [CellState] {
        return [.Living, .Empty, .Born, .Died]
    }
    
    func toggle(value:CellState) -> CellState {
        switch value {
        case .Empty, .Died:
            return .Living
        case .Living, .Born:
            return .Empty
        }
    }
}