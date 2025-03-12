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
            Image(vm.wishlistManager.isHotelLiked(hotel) ? "heartLike" : "heartUnlike")
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
    func toggleWishlist() {
        if vm.wishlistManager.isHotelLiked(hotel) {
            vm.wishlistManager.removeFromWishlist(hotel)
        } else {
            vm.wishlistManager.addToWishlist(hotel)
        }
    }
}
