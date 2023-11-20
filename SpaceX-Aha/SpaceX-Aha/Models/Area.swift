//
//  Area.swift
//  SpaceX-Aha
//
//  Created by Guo Siqi on 11/20/23.
//

import Foundation

/* Normally Objects in C#, while Enum is more powerful in Swift */

enum Area : String, Identifiable, CaseIterable, Equatable
{
    case astronauts, equipment, mission
    
    // Identify each Area
    var id :    Self    { self }
    var name :  String  { rawValue.lowercased() }
    // Identify the title for each one of the screens
    var title : String  {
        switch self {
        case.astronauts:
            "Rocket crew members..."
        case.equipment:
            "Rocket equipment..."
        case.mission:
            "Rocket trailer..."
        }
    }
}
