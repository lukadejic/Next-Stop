import SwiftUI

struct WishlistView: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    @EnvironmentObject var vm : HomeViewModel
    @State private var isLiked: Bool = false
    
    @State var showLikeNotification = false
    @State var showUnlikeNotification = false
    @State var wishlistChangedHotel: Hotel? = nil
    
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
                                            .overlay(alignment: .topLeading) {
                                                if isLiked {
                                                    RemoveButtonView(){
                                                        vm.removeFromWishlist(hotel)
                                                    }
                                                    .padding()
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
                        .padding(.top)
                        
                        Spacer()
                    }
                }else{
                    ContentUnavailableView("Wishlist is empty",
                                           systemImage: "house.fill")
                }
            }
            .onChange(of: vm.wishlist) { oldValue, newValue in
                vm.showNotification(oldValue, newValue)
            }
            .overlay(alignment: .bottom) {
                if let hotel = vm.wishlistChangedHotel {
                    LikeNotificationView(
                        showNotification: $vm.showLikeNotification,
                        hotel: hotel)
                    UnlikeNotificationView(
                        showNotification: $vm.showUnlikeNotification,
                        hotel: hotel)
                }
            }
            .onAppear{
                isLiked = false
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
