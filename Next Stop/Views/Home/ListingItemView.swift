import SwiftUI

struct ListingItemView: View {
    @State private var currentIndex = 0

    
    let images = [
        "image-1",
        "image-2",
        "image-3",
        "image-4"
    ]
    
    var body: some View {
        VStack(alignment: .leading){
            TabView(selection: $currentIndex){
                ForEach(images.indices , id: \.self){ index in
                    Image(images[index])
                        .resizable()
                        .scaledToFill()
                        .tag(index)
                }
            }
            .frame(height: 350)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .tabViewStyle(.page)
            .onAppear{
                startAutoScroll()
            }
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5){
                    Text("London, United Kingdom")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    
                    Text("Stay with Lena - Hosting for 8 years")
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.7))
                    
                    Text("May 8 - 13")
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.7))
                    
                    HStack(spacing: 4){
                        Text("$135")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("night")
                    }
                }
                
                Spacer()
                
                HStack(spacing: 4){
                    Image(systemName: "star.fill")
                    
                    Text("4.68")
                }
            }
        }
        .padding()
    }
}

#Preview {
    ListingItemView()
}

private extension ListingItemView {
    func startAutoScroll(){
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            withAnimation {
                currentIndex = (currentIndex + 1) % images.count
            }
        }
    }
}
