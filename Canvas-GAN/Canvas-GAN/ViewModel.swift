//
//  ViewModel.swift
//  Canvas-GAN
//
//  Created by Guo Siqi on 11/17/23.
//


import Foundation
import Observation

enum FlowState {
    case IDLE
    case INTRO
    case PROJECTILEFLYING
    case UPDATEWALLART
}


/* 
 * Wrapped with a swift Macro.
 * The swiftUI would listen to state in the view model and it will get updates.
 */
@Observable
class ViewModel {
    
    var flowState = FlowState.IDLE
    
}
