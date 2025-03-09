import SwiftUI

struct DestinationSearchView: View {
    @StateObject private var vm = SearchDestinationsViewModel(
        searchService: LocationSearchService())
    @EnvironmentObject private var homeVm : HomeViewModel
    
    @Binding var show: Bool
    @State private var buttonText: String = "Next"
    @State private var showButton : Bool = false
    @State private var showListings: Bool = false
    
    var body: some View {
        VStack{
           
            hearder
            
            whereToSection
            
            arrivalSection
            
            guestsSection
            
            Spacer()
        }
        .overlay(alignment: .bottom) {
            if !vm.search.isEmpty{
                SearchButtonView(vm: vm,
                                 selectedOption: $vm.searchOption,
                                 show: $showListings,
                                 homeVM: homeVm)
            }
        }
        .fullScreenCover(isPresented: $showListings) {
            NavigationStack{
                ListingsAfterSearchView(homeVM: homeVm,
                                        vm: vm,
                                        showHomeView: $show,
                                        showSearchView: $showListings)
            }
        }
    }
}

#Preview {
    DestinationSearchView(show: .constant(false))
        .environmentObject(HomeViewModel(hotelsService: HotelsService()))
}

struct CollapsedPickerView : View {
    let title: String
    let description: String
    
    var body: some View {
        VStack {
            HStack{
                Text(title)
                    .foregroundStyle(.gray)
                
                Spacer()
                
                Text(description)
                    .fontWeight(.semibold)
                    .font(.subheadline)
            }
        }
    }
}

struct GuestsSelectionView: View {
    @ObservedObject var vm : SearchDestinationsViewModel
    let guest: String
    let age: String
    @State private var numberOfGuests: Int = 0
    @State var guestsSelection: GuestsSelection
    
    var body: some View {
        VStack{
            
            HStack{
                VStack(alignment:.leading){
                    Text(guest)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text(age)
                        .font(.caption)
                }
                
                Spacer()
                
                HStack(spacing: 15) {
                    Button{
                        decreaseCount()
                    }label: {
                        Image(systemName: "minus")
                            .frame(width: 25, height: 25)
                            .background(Circle()
                                .stroke(lineWidth: 1))
                            .foregroundStyle(isMinusDisabled() ? .black.opacity(0.3) : .black.opacity(0.6))
                            .imageScale(.small)
                    }
                    .disabled(isMinusDisabled())
  
                    Text("\(numberOfGuestsForSelection())")
                                            .frame(height: 25)
                    
                    Button{
                        increaseCount()
                    }label: {
                        Image(systemName: "plus")
                            .frame(width: 25, height: 25)
                            .background(Circle()
                                .stroke(lineWidth: 1))
                            .foregroundStyle(isPlusDisabled() ? .black.opacity(0.3) : .black.opacity(0.6))
                            .imageScale(.small)
                    }
                    .disabled(isPlusDisabled())
                }
            }
            
            
        }
    }

}
    
struct SearchButtonView: View {
    let vm: SearchDestinationsViewModel
    @Binding var selectedOption: DestinationSearchOption
    @Binding var show: Bool
    @ObservedObject var homeVM : HomeViewModel
    
    var body: some View {
        HStack {
            Button {
                moveToNextOption()
            } label: {
                Text(selectedOption == .destination || selectedOption == .dates ? "Skip" : "Clear all")
                    .fontWeight(.semibold)
                    .underline()
            }
            .tint(.black)
            
            Spacer()
            
            Button {
                handleNextOrSearch()
            } label: {
                HStack(spacing: 10) {
                    if selectedOption == .guests || selectedOption == .none {
                        Image(systemName: "magnifyingglass")
                    }

                    Text(isSearchButton ? "Next" : "Search")
                }
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width: 130, height: 45)
                .background(isSearchButton ? Color.black :
                                Color.pink.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 7)
            }
        }
        .padding(.horizontal)
        .padding()
    }
}

private extension DestinationSearchView {
    var hearder : some View {
        HStack{
            Button{
                withAnimation(.easeOut(duration: 0.3)){
                    show.toggle()
                }
            }label: {
                Image(systemName: "xmark.circle")
                    .foregroundStyle(.black)
            }
            
            Spacer()
            
        }
        .padding()
    }
    
    var whereToSection: some View {
            VStack(alignment: .leading) {
                if vm.searchOption == .destination {
                    VStack(alignment: .leading) {
                        Text("Where to?")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .imageScale(.small)
                            
                            TextField("Search Destinations", text: $vm.searchService.query)
                                .font(.subheadline)
                        }
                        .frame(height: 44)
                        .padding(.horizontal)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 1)
                                .foregroundStyle(Color(.systemGray4))
                        }

                        if vm.searchService.results.isEmpty {
                            ContentUnavailableView("No Results", image: "")
                        } else {
                            List(vm.searchService.results) { result in
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(result.title)
                                    Text(result.subtitle)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .onTapGesture {
                                    vm.search = result.title
                                    withAnimation(.snappy) {
                                        vm.searchOption = .dates
                                        showButton = true
                                    }
                                }
                            }
                            .listStyle(.plain)
                        }
                        
                        Spacer()
                    }
                } else {
                    CollapsedPickerView(
                        title: vm.search.isEmpty ? "Where to?" : "Selected Location",
                        description: vm.search.isEmpty ? "Add destination" : vm.search)
                }
            }
            .frame(height: vm.searchOption == .destination ? 400 : 30)
            .modifier(CollapsibleDestinationViewModifier())
            .onTapGesture {
                withAnimation(.snappy) { vm.searchOption = .destination }
            }
        }
    
    var arrivalSection : some View {
        VStack {
            if vm.searchOption == .dates {
                SearchCalendarView(vm: vm)
            }else{
                CollapsedPickerView(title: "When",
                                    description: vm.startDate != nil &&
                                    vm.endDate != nil ? CalendarHelpers.formattedRangeDate(startDate: vm.startDate, endDate: vm.endDate) ?? "" : "Add dates")
            }
        }
        .modifier(CollapsibleDestinationViewModifier())
        .frame(height: vm.searchOption == .dates ? 450 : 64)
        .onTapGesture {
            withAnimation(.snappy) { vm.searchOption = .dates}
        }
    }
    
    var guestsSection: some View {
            VStack {
                if vm.searchOption == .guests {
                    VStack(alignment: .leading) {
                        Text("Who's coming?")
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding(.top, 10)
                        Spacer()
                        
                        VStack(spacing: 15) {
                            ForEach(vm.guestDetails, id: \.guest) { guestDetail in
                                GuestsSelectionView(vm: vm, guest: guestDetail.guest, age: guestDetail.age, guestsSelection: guestDetail.selection)
                                
                                if guestDetail != vm.guestDetails.last! {
                                    Divider()
                                }
                            }
                        }
                    }
                } else {
                    CollapsedPickerView(title: "Who", description: vm.numberOfGuests == 0 ? "Add guests" : "\(vm.numberOfGuests) guests")
                }
            }
            .frame(height: vm.searchOption == .guests ? 300 : 34)
            .modifier(CollapsibleDestinationViewModifier())
            .onTapGesture {
                withAnimation(.snappy) { vm.searchOption = .guests }
                buttonText = "Search"
            }
        }

}
