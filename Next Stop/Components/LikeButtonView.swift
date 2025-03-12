import SwiftUI

struct LikeButtonView: View {
    @Binding var isLiked: Bool
    @EnvironmentObject var vm: HomeViewModel
    let hotel: Hotel
    
    var body: some View {
        Button{
            withAnimation(.snappy) {
                toggleWishlist()
            }
        }label: {
            Image(vm.isHotelLiked(hotel) ? "heartLike" : "heartUnlike")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .padding(12)
                .background(
                    Circle()
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                )
                .shadow(radius: 4)
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    LikeButtonView(isLiked: .constant(false), hotel: MockData.mockHotel)
        .environmentObject(HomeViewModel(hotelsService: HotelsService()))
}

private extension LikeButtonView {
    func addToWishlist() {
        if isLiked{
            if !vm.wishlist.contains(where: {$0.hotelID ==  hotel.hotelID}){
                vm.wishlist.append(hotel)
                print("added...")
            }
        }else{
            vm.wishlist.removeAll(where: {$0.hotelID == hotel.hotelID})
            print("deleted")
        }
    }
    
    func toggleWishlist() {
        if vm.isHotelLiked(hotel) {
            vm.removeFromWishlist(hotel)
        } else {
            vm.addToWishlist(hotel)
        }
    }
}
