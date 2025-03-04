import SwiftUI

struct DestinationSearchView: View {
    @StateObject private var vm = SearchDestinationsViewModel()
    
    @Binding var show: Bool
    
    @State  private var search: String = ""
    @State  private var selectedOption : DestinationSearchOption = .destination
    
    var body: some View {
        VStack{
           
            hearder
            
            whereToSection
            
            arrivalSection
            
            guestsSection
            
            Spacer()
        }
       
    }
}

#Preview {
    DestinationSearchView(show: .constant(false))
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
            
            if !search.isEmpty {
                Button("Clear") {
                    search = ""
                }
                .foregroundStyle(.black)
                .font(.subheadline)
                .fontWeight(.semibold)
            }
        }
        .padding()
    }
    
    var whereToSection : some View {
        
        VStack(alignment:.leading) {
            if selectedOption == .destination {
                Text("Where to?")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .imageScale(.small)
                    
                    TextField("Search Destinations", text: $search)
                        .font(.subheadline)
                }
                .frame(height: 44)
                .padding(.horizontal)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(Color(.systemGray4))
                }
            }else{
                CollapsedPickerView(title: "Where to?",
                                    description: "Add destination")
            }
        }
        .modifier(CollapsibleDestinationViewModifier())
        .onTapGesture {
            withAnimation(.snappy) { selectedOption = .destination}
        }

    }
    
    var arrivalSection : some View {
        VStack {
            if selectedOption == .dates {
                SearchCalendarView()
            }else{
                CollapsedPickerView(title: "When",
                                    description: "Add dates")
            }
        }
        .modifier(CollapsibleDestinationViewModifier())
        .frame(height: selectedOption == .dates ? 600 : 64)
        .onTapGesture {
            withAnimation(.snappy) { selectedOption = .dates}
        }
    }
    
    var guestsSection : some View {
        VStack {
            if selectedOption == .guests {
                VStack(alignment: .leading) {
                    Text("Who's coming?")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.top,10)
                    Spacer()
                    
                    VStack(spacing: 15) {
                        ForEach(vm.guestDetails, id: \.guest) { guestDetail in
                            GuestsSelectionView(vm: vm,
                                                guest: guestDetail.guest,
                                                age: guestDetail.age,
                                                guestsSelection: guestDetail.selection)
                            
                            if guestDetail != vm.guestDetails.last! {
                                Divider()
                            }
                        }
                    }
                }
                
            }else{
                CollapsedPickerView(title: "Who",
                                    description: vm.numberOfGuests == 0 ? "Add guests" : "\(vm.numberOfGuests) guests")
            }
        }
        .frame(height: selectedOption == .guests ? 300 : 34)
        .modifier(CollapsibleDestinationViewModifier())
        .onTapGesture {
            withAnimation(.snappy) { selectedOption = .guests}
        }
    }
}
