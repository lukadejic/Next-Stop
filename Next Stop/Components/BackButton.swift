//
//  BackButton.swift
//  Next Stop
//
//  Created by MacBook on 2/2/25.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
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
        }
        .foregroundStyle(.black)
        .padding(32)
        .allowsHitTesting(true)
    }
}

#Preview {
    BackButton()
}
