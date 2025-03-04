import SwiftUI

enum DestinationSearchOption {
    case destination
    case dates
    case guests
}

struct DestinationSearchView: View {
    @StateObject private var vm = SearchDestinationsViewModel()
    
    @Binding var show: Bool
    @State private var search: String = ""
    @State private var selectedOption : DestinationSearchOption = .destination
    @State private var numberOfGuests: Int = 0
    
    var body: some View {
        VStack{
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
            
            VStack {
                if selectedOption == .guests {
                    VStack(alignment: .leading) {
                        Text("Who's coming?")
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding(.top,10)
                        Spacer()
                        VStack(spacing: 15) {
                            GuestsSelectionView(vm: vm,
                                                guest: "Adults",
                                                age: "Age 13 or above", guestsSelection: .adults)
                            
                            
                            Divider()
                            
                            GuestsSelectionView(vm: vm,
                                                guest: "Children",
                                                age: "Ages 2-12", guestsSelection: .childred)
                            
                            Divider()

                            GuestsSelectionView(vm: vm,
                                                guest: "Infants",
                                                age: "Under 2", guestsSelection: .infants)
                            
                            Divider()
                            
                            GuestsSelectionView(vm: vm,
                                                guest: "Pets",
                                                age: "",
                                                guestsSelection: .pets)
                            
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

struct CollapsibleDestinationViewModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 10)
            .padding()
    }
}
    

