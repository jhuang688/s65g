//
//  CellState.swift
//  FinalProject
//
//  Created by Joanne Huang on 6/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

import Foundation

enum CellState : String {
    case Living = "Living"
    case Empty = "Empty"
    case Born = "Born"
    case Died = "Died"
    case Diseased = "Diseased"
    
    // returns raw value
    func description() -> String {
        return self.rawValue
    }
    
    // returns array of all values
    static func allValues() -> [CellState] {
        return [.Living, .Empty, .Born, .Died, .Diseased]
    }
    
    // toggles CellState from dead to living and vice versa
    func toggle(value:CellState) -> CellState {
        switch value {
        case .Empty, .Died, .Diseased:
            return .Living
        case .Living, .Born:
            return .Empty
        }
    }
    
    // returns true if alive, false if dead
    func isAlive() -> Bool {
        switch self {
        case .Living, .Born, .Diseased: return true
        case .Died, .Empty: return false
        }
    }
}