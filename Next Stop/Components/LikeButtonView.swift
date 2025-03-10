import SwiftUI

struct LikeButtonView: View {
    @Binding var isLiked: Bool
    @EnvironmentObject var vm: HomeViewModel
    let hotel: Hotel
    
    var body: some View {
        Button{
            withAnimation(.snappy){
                isLiked.toggle()
            }
            addToWishlist()
        }label: {
            Image(isLiked ? "heartLike" : "heartUnlike")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .padding()
                .foregroundStyle(.black.opacity(0.8))
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
}
