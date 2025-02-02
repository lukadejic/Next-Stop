//
//  ListingImageCarouselView.swift
//  Next Stop
//
//  Created by MacBook on 1/31/25.
//

import SwiftUI

struct ListingImageCarouselView: View {
    @State private var currentIndex = 0
    
    let images = [
        "image-1",
        "image-2",
        "image-3",
        "image-4"
    ]
    
    var body: some View {
        TabView(selection: $currentIndex){
            ForEach(images.indices , id: \.self){ index in
                Image(images[index])
                    .resizable()
                    .scaledToFill()
                    .tag(index)
            }
        }
        .tabViewStyle(.page)
        .onAppear{
            startAutoScroll()
        }
    }
    func startAutoScroll(){
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            withAnimation {
                currentIndex = currentIndex + 1 
            }
        }
    }
}



#Preview {
    ListingImageCarouselView()
}
