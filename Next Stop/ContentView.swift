//
//  ContentView.swift
//  Next Stop
//
//  Created by MacBook on 1/25/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                    .foregroundStyle(.red)
            }
            .navigationTitle("Next Stop")
            
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
