//
//  Areas.swift
//  SpaceX-Aha
//
//  Created by Guo Siqi on 11/20/23.
//

/* Areas:
 * The Navigation Component, to allow us to push different windows
 * - Create a new Group.
 * - This would be the group tag.
 */
import SwiftUI

struct Areas: View {
    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        ZStack {
            NavigationStack {
                
                // All the navigation links
                NavigationToArea()
                
            }
        }
    }
}

#Preview {
    Areas()
}
