import SwiftUI

struct ListingsAfterSearchView: View {
    @ObservedObject var homeVM : HomeViewModel
    let vm: SearchDestinationsViewModel
    
    var body: some View {
        NavigationView{
            VStack{
                ScrollView {
                    Text("\(homeVM.hotels.count) places")
                        .fontWeight(.medium)

                    LazyVStack(spacing: 30) {
                        ForEach(0..<5) { hotel in
//                            NavigationLink {
//                                ListingDetailView(hotel: MockData.mockHotel)
//                            } label: {
//                                ListingItemView(hotel: MockData.mockHotel)
//                            }
                        }
                    }
                    .padding(.horizontal,10)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        
                    }label: {
                        Image(systemName: "arrow.left")
                    }
                    .tint(.black)
                    .padding(.horizontal)
                    .padding(.top,30)
                }
                
                ToolbarItem(placement: .principal) {
                    Button{
                        
                    }label: {
                        VStack{
                            Text(vm.search)
                                .fontWeight(.medium)
                                                            
                            HStack(spacing: 0) {
                                if vm.startDate == nil && vm.endDate == nil {
                                    Text("Any week ")
                                        .font(.system(size: 10))
                                }else {
                                    Text(CalendarHelpers.formattedRangeDate(startDate: vm.startDate, endDate: vm.endDate) ?? "")
                                        .font(.system(size: 10))
                                }

                                if vm.numberOfGuests > 0 {
                                    Text(" - \(vm.numberOfGuests) guests")
                                        .font(.system(size: 10))
                                }else{
                                    Text("- Add guests")
                                        .font(.system(size: 10))
                                }
                            }
                        }
                        .frame(width: 220, height: 50)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .shadow(radius: 3)
                        .padding(.top,30)
                    }
                    .tint(.black)
                    .padding(.horizontal)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        
                    }label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .padding(.top,30)
                    }
                    .tint(.black)
                    .padding(.horizontal)
                }
            }
        }
        .tint(.black)
    }
}

#Preview {
    ListingsAfterSearchView(
        homeVM: HomeViewModel(
            hotelsService: HotelsService()),
        vm: SearchDestinationsViewModel(searchService: LocationSearchService()))
        .environmentObject(HomeViewModel(hotelsService: HotelsService()))
}
