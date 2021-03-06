//
//  CellState.swift
//  Assignment3
//
//  Created by Joanne Huang on 6/07/2016.
//  Copyright © 2016 Joanne Huang. All rights reserved.
//

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
        //        switch self {
        //        case .Living:
        //            return Living.rawValue
        //        case .Empty:
        //            return Empty.rawValue
        //        case .Born:
        //            return Born.rawValue
        //        case .Died:
        //            return Died.rawValue
        //        }
        return self.rawValue
    }
    
    static func allValues() -> [CellState] {
        //        var allValues: [CellState]
        //        for state in CellState {
        //            allValues += CellState.state    // verify if this works - probably doesn't
        //        }
        //
        //        return allValues
        return [.Living, .Empty, .Born, .Died]
    }
    
    // LEADING DOT???
    
    func toggle(value:CellState) -> CellState {
        switch value {
        case .Empty, .Died:
            return .Living
        case .Living, .Born:
            return .Empty
        }
    }
    
    //static func toggle2(value: CellState) -> CellState {
    func toggle2(value: CellState) -> CellState {
    
        switch value {
            
        case .Living:
            
            return .Empty
            
        case .Born:
            
            return .Empty
            
        case .Died:
            
            return .Living
            
        case .Empty:
            
            return .Living
            
            
            
        }
        
    }
}

CellState.allValues()
CellState.Living.toggle(.Living)
CellState.Died.toggle(.Died)
CellState.Born.description()




CellState.toggle2(.Died) // will output " CellState -> CellState"

CellState.Died.toggle2(.Died) // will output living

