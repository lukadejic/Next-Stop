import SwiftUI

struct ListingsAfterSearchView: View {
    @ObservedObject var homeVM : HomeViewModel
    let vm : SearchDestinationsViewModel
    
    var body: some View {
        VStack{
            if homeVM.hotels.isEmpty {
                ProgressView()
            }else {
                ZStack{
                    ScrollView {
                        LazyVStack(spacing: 30) {
                            ForEach(homeVM.hotels) { hotel in
                                NavigationLink {
                                    ListingDetailView(hotel: hotel)
                                } label: {
                                    ListingItemView(hotel: hotel)
                                }
                            }
                        }
                        .padding(.horizontal,10)
                    }
                }
            }
        }
        .onAppear{
            homeVM.searchHotels(location: vm.search,
                                arrivalDate: vm.manager.startDate,
                                departureDate: vm.manager.endDate,
                                adults: vm.numberOfAdults,
                                childredAge: 1,
                                roomQty: vm.numberOfRooms)
            
        }
    }
}

#Preview {
    ListingsAfterSearchView(
        homeVM: HomeViewModel(hotelsService: HotelsService()),
        vm: SearchDestinationsViewModel(searchService: LocationSearchService()))
        .environmentObject(HomeViewModel(hotelsService: HotelsService()))
}
