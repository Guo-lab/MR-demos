//
//  ViewModel.swift
//  SpaceX-Aha
//
//  Created by Guo Siqi on 11/20/23.
//

import Foundation

// If some of views were changed, only the views that are reading specific properties are updated
@Observable
class ViewModel {
    var navigationPath: [Area] = []
    
    // To toggle volumetric & immersive windows
    var isShowingRocketCapsule: Bool = false
    var isShowingFullRocketCapsule: Bool = false
}
