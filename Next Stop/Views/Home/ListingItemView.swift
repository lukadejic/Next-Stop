import SwiftUI

struct ListingItemView: View {
    let hotel : Hotel
    @EnvironmentObject var vm : HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            
            if let images = vm.hotelImages[hotel.hotelID ?? 0], !images.isEmpty {
                ListingImageCarouselView(images: images)
                    .frame(height: 350)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
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
                    
                    Text("Stay with Lena - Hosting for 8 years")
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.7))
                    
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


private extension ListingItemView {
    func stayDate(arrivalDate: String?, departureDate: String?) -> String {
        
        guard let arrival = arrivalDate, let departure = departureDate else { return "unknow"}
        
        let inputFormater = DateFormatter()
        inputFormater.dateFormat = "yyyy-MM-dd"
        inputFormater.locale = Locale(identifier: "en_US_POSIX")
        
        let outputFormater = DateFormatter()
        outputFormater.dateFormat = "d"
        
        let monthFormater = DateFormatter()
        monthFormater.dateFormat = "MMM"
        
        if let arrivalDate = inputFormater.date(from: arrival),
           let departureDate = inputFormater.date(from: departure){
            
            let arrivalDay = outputFormater.string(from: arrivalDate)
            let departureDay = outputFormater.string(from: departureDate)
            let month = monthFormater.string(from: departureDate)
            
            return "\(arrivalDay) - \(departureDay) \(month)"
        }

        return "unknown"
    }
}
