import SwiftUI

struct ListingItemView: View {
    let hotelID : Int
    @EnvironmentObject var vm : HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            
            if let images = vm.hotelImages[hotelID], !images.isEmpty {
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
                    Text("London, United Kingdom")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    
                    Text("Stay with Lena - Hosting for 8 years")
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.7))
                    
                    Text("May 8 - 13")
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.7))
                    
                    HStack(spacing: 4){
                        Text("$135")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("night")
                    }
                }
                
                Spacer()
                
                HStack(spacing: 4){
                    Image(systemName: "star.fill")
                    
                    Text("4.68")
                }
            }
        }
        .padding()
        .onAppear{
            if vm.hotelImages[hotelID] == nil {
                vm.getHotelImages(hotelID: hotelID)
            }
        }
    }
}

#Preview {
    ListingItemView(hotelID: 1)
        .environmentObject(HomeViewModel(hotelsService: HotelsService()))
}

