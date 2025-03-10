import SwiftUI

struct ListingItemView: View {
    let hotel : Hotel
    @EnvironmentObject var vm : HomeViewModel
    @State private var isLiked = false
    
    var body: some View {
        VStack(alignment: .leading){
            
            if let images = vm.hotelImages[hotel.hotelID ?? 0], !images.isEmpty {
                ListingImageCarouselView(images: images)
                    .frame(height: 350)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(alignment: .topTrailing) {
                        LikeButtonView(isLiked: $isLiked,
                                       hotel: hotel)
                    }
            } else {
                ProgressView()
                    .frame(height: 350)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .offset(x: 160)
            }

            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5){
                    Text(vm.hotelDetail?.hotel_name ?? "Unknown")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                    
                    Text(stayDate(arrivalDate: vm.hotelDetail?.arrival_date, departureDate: vm.hotelDetail?.departure_date))
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.7))
                    
                    HStack(spacing: 4){
                        Text(String(format: "$%.2f", vm.hotelDetail?.product_price_breakdown?.charges_details?.amount?.value ?? 0.0))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("night")
                    }
                }
                
                Spacer()
                
                HStack(spacing: 4){
                    Image(systemName: "star.fill")
                    
                    Text(String(format: "%.2f",
                                hotel.property?.reviewScore ?? 0.0))
                }
            }
        }
        .padding()
        .onAppear{
            if vm.hotelImages[hotel.hotelID ?? 0] == nil {
                vm.getHotelImages(hotelID: hotel.hotelID ?? 0)
            }
            vm.getHotelDetails(hotelId: hotel.hotelID ?? 0)
        }
    }
}

#Preview {
    ListingItemView(hotel: MockData.mockHotel)
        .environmentObject(HomeViewModel(hotelsService: HotelsService()))
}
