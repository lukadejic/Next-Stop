import SwiftUI

struct ListingsAfterSearchView: View {
    @ObservedObject var homeVM : HomeViewModel
    let vm: SearchDestinationsViewModel
    @State private var noResults = false
    @Binding var showHomeView: Bool
    @Binding var showSearchView: Bool
    
    var body: some View {
        VStack{
            if homeVM.isLoading {
                ProgressView("Loading hotels...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline:.now() + 10){
                            homeVM.isLoading = false
                            noResults = true
                        }
                    }
            }else if noResults && homeVM.hotels.isEmpty {
                ContentUnavailableView("No results",
                                       systemImage: "house")
            }else{
                ScrollView {
                    if !homeVM.isLoading {
                        Text("\(homeVM.hotels.count) places")
                            .fontWeight(.medium)
                            .padding(.top,20)
                    }
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                Button{
                    withAnimation(.easeOut) {
                        showHomeView.toggle()
                    }
                }label: {
                    Image(systemName: "arrow.left")
                }
                .tint(.black)
                .padding(.horizontal)
                .padding(.top,30)
            }
            
            ToolbarItem(placement: .principal) {
                Button{
                    withAnimation(.snappy) {
                        showSearchView.toggle()
                    }
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
        .tint(.black)
    }
}

#Preview {
    ListingsAfterSearchView(
        homeVM: HomeViewModel(
            hotelsService: HotelsService()),
        vm: SearchDestinationsViewModel(searchService: LocationSearchService()),
        showHomeView: .constant(false),
        showSearchView: .constant(false))
        .environmentObject(HomeViewModel(hotelsService: HotelsService()))
}
