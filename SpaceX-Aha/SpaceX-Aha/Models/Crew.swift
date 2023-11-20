//
//  Crew.swift
//  SpaceX-Aha
//
//  Created by Guo Siqi on 11/20/23.
//

import Foundation

enum Crew : String, Identifiable, CaseIterable, Equatable
{
    case Jared, Hayley, Chris, Sian
    
    var id          :   Self    { self }
    var fullName    :   String  {
        switch self {
        case.Jared  :   "Jared Isaacman"
        case.Hayley :   "Hayley Arceneaux"
        case.Chris  :   "Chris Sembroski"
        case.Sian   :   "Dr. Sian Proctor"
        }
    }
    var about       :   String {
        switch self {
        case.Jared  :   "Jared Isaacman is the founder and CEO of Shift4 Payments (NYSE: FOUR), the leader in integrated payment processing solutions."
        case.Hayley :   "She now works at St. Jude – the very place that saved her life – as a PA with leukemia and lymphoma patients."
        case.Chris  :   "He now resides in Seattle, WA, and works in the aerospace industry."
        case.Sian   :   "Dr. Sian Proctor is a geoscientist, explorer, and science communication specialist with a lifelong passion for space exploration."
        }
    }
}
