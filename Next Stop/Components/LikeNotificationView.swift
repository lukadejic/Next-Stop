import SwiftUI

struct LikeNotificationView: View {
    @Binding var showNotification: Bool
    @EnvironmentObject var vm : HomeViewModel
    let hotel: Hotel
    
    var body: some View {
        
        VStack {
            HStack(spacing: 32){
                
                if let image = vm.hotelImages[hotel.hotelID ?? 1]?.first {
                    ListingImageCarouselView(images: [image])
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .frame(width: 55, height: 55)
                }else {
                    ProgressView()
                        .frame(width: 55, height: 55)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                
                
                VStack(alignment: .leading,spacing: -20) {
                    HStack{
                        
                        Text("Saved")
                        
                        Text(hotel.property?.name ?? "")
                            .lineLimit(1)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                        
                        }
                        Text("\nto the wishlist.")
                            .truncationMode(.tail)
                    
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
            }
            .padding(10)
        }
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 10)
        .padding()
        .offset(y: showNotification ? 0 : 300)
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: showNotification)
    }
}

#Preview {
    LikeNotificationView(showNotification: .constant(false),
                         hotel: MockData.mockHotel)
        .environmentObject(HomeViewModel(hotelsService: HotelsService()))
}
