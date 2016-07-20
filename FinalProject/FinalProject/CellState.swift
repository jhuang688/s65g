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
    
    // returns raw value
    func description() -> String {
        return self.rawValue
    }
    
    // returns array of all values
    static func allValues() -> [CellState] {
        return [.Living, .Empty, .Born, .Died]
    }
    
    // toggles CellState from dead to living and vice versa
    func toggle(value:CellState) -> CellState {
        switch value {
        case .Empty, .Died:
            return .Living
        case .Living, .Born:
            return .Empty
        }
    }
}