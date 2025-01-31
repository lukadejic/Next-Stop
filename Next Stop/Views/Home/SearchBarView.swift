//
//  SearchBarView.swift
//  Next Stop
//
//  Created by MacBook on 1/31/25.
//

import SwiftUI

struct SearchBarView: View {
    var action : (() -> ())?
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
            
            VStack(alignment: .leading,spacing: 5){
                Text("Where to?")
                    .font(.footnote)
                    .fontWeight(.semibold)
                
                Text("Anywhere - Any Week - Add Guests")
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Button{
                action?()
            }label: {
                Image(systemName:"line.3.horizontal.decrease.circle")
                    .foregroundStyle(.black)
            }
        }
        .padding(.horizontal)
        .padding(.vertical,10)
        .overlay {
            Capsule()
                .stroke(lineWidth: 0.2)
                .shadow(color: .black.opacity(0.4), radius: 10)
        }
        .padding()
    }
}

#Preview {
    SearchBarView()
}
