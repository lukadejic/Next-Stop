//
//  BackButton.swift
//  Next Stop
//
//  Created by MacBook on 2/2/25.
//

import SwiftUI

struct BackButton: View {

    var body: some View {
        
        Image(systemName: "chevron.left")
            .resizable()
            .scaledToFit()
            .frame(width: 16, height: 16)
            .padding(12)
            .background(
                Circle()
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
            )
            .shadow(radius: 4)
            .foregroundStyle(.black)
            .allowsHitTesting(true)
    }
}

#Preview {
    BackButton()
}
