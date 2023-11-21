//
//  CrewArea.swift
//  SpaceX-Aha
//
//  Created by Guo Siqi on 11/20/23.
//

import SwiftUI

struct CrewArea: View {
    var body: some View {
        HStack {
            
            ForEach(Crew.allCases) { crew in
                VStack(alignment: .leading) {
                    Image("crew-\(crew.name)")
                        .resizable()
                        .frame(width: 180, height: 200)
                    
                    Text(crew.fullName)
                        .font(.system(size: 30, weight: .bold))
                    
                    Text(crew.about)
                        .font(.system(size: 22))
                }
                .frame(minWidth: 180, minHeight: 200)
                .padding(10)
                .glassBackgroundEffect()
            }
            
        }
        .padding(20)
    }
}

#Preview {
    CrewArea()
}
