import SwiftUI

struct HomeView: View {

    @EnvironmentObject var vm : HomeViewModel
    
    @State private var selectedStayOption: StayOptionType = .lakeFront
    @State private var showDestinationSearchView = false
    
    var body: some View {
        NavigationStack{
            if showDestinationSearchView {
                DestinationSearchView(show: $showDestinationSearchView)
            }else{
                ZStack {
                    VStack {
                        SearchBarView()
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    showDestinationSearchView.toggle()
                                }
                            }
                        
                        stayOptionsHeader
                        
                        listingList
                    }
                }
    //            .onAppear {
    //                if vm.destinations.isEmpty {
    //                    vm.getDestinations(query: selectedStayOption.querryKeywords)
    //                }
    //            }
    //            .onChange(of: selectedStayOption) { odlValue, newValue in
    //                vm.getDestinations(query: newValue.querryKeywords)
    //            }
    //            .onChange(of: vm.destinations) { oldValue,newValue in
    //                guard !newValue.isEmpty else { return }
    //                if vm.selectedDestination == nil || !newValue.contains(where: { $0.id == vm.selectedDestination?.id }) {
    //                    vm.selectDestination(for: selectedStayOption.querryKeywords)
    //                }
    //            }
            }

        }
    }
}

private extension HomeView {
    var stayOptionsHeader: some View {
        ScrollView(.horizontal){
            HStack {
                ForEach(StayOptionType.allCases, id: \.self) { option in
                    stayOptionView(for: option)
                }
            }
        }
    }
    
    func stayOptionView(for option: StayOptionType) -> some View {
        HStack(spacing: 32) {
            VStack {
                Image(systemName: option.imageName)
                    .fontWeight(.light)
                    .foregroundStyle(.black.opacity(0.8))
                    .frame(width: 30, height: 40)
                    .font(.title)
                
                Text(option.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                
                
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 50, height: 2)
                    .padding(.top, 5)
                    .opacity(selectedStayOption == option ? 1 : 0)
            }
            .padding(.horizontal,10)
            .frame(height: 102)
            .scaleEffect(
                withAnimation(.easeOut, {
                    selectedStayOption == option ? 1.2 : 1
                })
                
            )
            .onAppear{
                if(selectedStayOption == option){
                    print(option.querryKeywords)
                }
            }
            .opacity(selectedStayOption == option ? 1 : 0.5)
            .onTapGesture {
                print("Fetching destinations for: \(option.querryKeywords)")
                
                withAnimation {
                    selectedStayOption = option
                }
                
                vm.getDestinations(query: option.querryKeywords)
            }
        }
    }
    
    var listingList : some View {
        ScrollView{
            LazyVStack(spacing: 30) {
                ForEach(vm.hotels) { hotel in
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

#Preview {
    HomeView()
        .environmentObject(HomeViewModel(hotelsService: HotelsService()))
}
