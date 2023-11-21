//
//  NavigationToAreas.swift
//  SpaceX-Aha
//
//  Created by Guo Siqi on 11/20/23.
//

import SwiftUI

struct NavigationToAreas: View {
    var body: some View {
           VStack {
               Text("Welcome to SpaceX")
                   .monospaced() // for fixed width
                   .font(.system(size: 60, weight: .bold))
                   .padding(.top, 450)
               
               HStack(spacing: 50) {
                   // Area enum in Models:
                   //      case astronauts, equipment, mission
                   ForEach(Area.allCases) { area in
                       NavigationLink {
                           // To the Navigation Page
                           Text(area.title)
                               .monospaced()
                               .font(.system(size: 60, weight: .bold))
                           // Link Page
                           if area == Area.astronauts      { CrewArea() }
                           else if area == Area.equipment  { EquipmentArea() }
                           else if area == Area.mission    { MissionArea() }
                           
                           Spacer()
                       } label: {
                           Label(area.name, systemImage: "chevron.right")
                               .monospaced()
                               .font(.title)
                       }
                       // Button Size
                       .controlSize(.extraLarge)
                   }
               }
               
           }
           // bg for the VStack
           // imported from Assets
           .background() { Image("Inspiration4") }
       }
}

#Preview {
    NavigationToAreas()
        .environment(ViewModel())
}
