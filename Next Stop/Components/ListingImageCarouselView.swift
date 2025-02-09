import SwiftUI

struct ListingImageCarouselView: View {
    @State private var currentIndex = 0
    let images : [ImageModel]
    
    var body: some View {
        TabView(selection: $currentIndex){
            ForEach(images) { image in
                AsyncImage(url: URL(string: image.url)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure:
                        Image(systemName: "photo")
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
        .tabViewStyle(.page)
    }
}



#Preview {
    ListingImageCarouselView(images: MockData.mockHotelImages)
}
