import SwiftUI

struct WishlistView: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    @EnvironmentObject var vm : HomeViewModel
    @State private var isLiked: Bool = false
    
    var body: some View {
        NavigationView {
            VStack{
                if !vm.wishlist.isEmpty{
                    ScrollView {
                        LazyVGrid(columns: columns,spacing: 32) {
                            ForEach(vm.wishlist) { hotel in
                                VStack(alignment: .leading){
                                    if let images = vm.hotelImages[hotel.hotelID ?? 0], !images.isEmpty {
                                        ListingImageCarouselView(images: images)
                                            .frame(width: 170, height: 170)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .overlay(alignment: .topTrailing) {
                                                if isLiked {
                                                    LikeButtonView(isLiked: $isLiked,
                                                                   hotel: hotel)
                                                }
                                            }
                                    } else {
                                        ProgressView()
                                            .frame(width: 170, height: 170)
                                    }
                                    
                                    Text(hotel.property?.name ?? "Unknown")
                                        .font(.caption)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(2)
                                }
                                .frame(width: 170, height: 170)
                            }
                        }
                        Spacer()
                    }
                }else{
                    ContentUnavailableView("Wishlist is empty",
                                           systemImage: "house.fill")
                }
            }
            .navigationTitle("Wishlists")
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        withAnimation(.snappy) {
                            isLiked.toggle()
                        }
                    }label: {
                        Text("Edit")
                            .font(.title3)
                            .fontWeight(.medium)
                            .underline()
                    }
                }
            }
        }
        .tint(.black)
    }
}

#Preview {
    WishlistView()
        .environmentObject(HomeViewModel(hotelsService: HotelsService()))
}
