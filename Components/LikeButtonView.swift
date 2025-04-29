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
        .environmentObject(HomeViewModel(hotelsService: HotelsService(networkManager: NetworkManager())))
}

private extension LikeButtonView {    
    func toggleWishlist() {
        if vm.isHotelLiked(hotel) {
            vm.removeFromWishlist(hotel)
        } else {
            vm.addToWishlist(hotel)
        }
    }
}
