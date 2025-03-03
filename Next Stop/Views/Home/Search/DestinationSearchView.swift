import SwiftUI

enum DestinationSearchOption {
    case destination
    case dates
    case guests
}

struct DestinationSearchView: View {
    @Binding var show: Bool
    @State private var search: String = ""
    @State private var selectedOption : DestinationSearchOption = .destination
    
    var body: some View {
        VStack{
            Button{
                withAnimation(.easeOut(duration: 0.3)){
                    show.toggle()
                }
            }label: {
                Image(systemName: "xmark.circle")
                    .foregroundStyle(.black)
            }
            
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
                    CollapsedPickerView(title: "Where to?", description: "Add destination")
                }
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 10)
            .padding()
            .onTapGesture {
                withAnimation(.snappy) { selectedOption = .destination}
            }
            
            VStack {
                if selectedOption == .dates {
                    HStack{
                        Text("Expanded View")
                        
                        Spacer()
                    }
                }else{
                    CollapsedPickerView(title: "When",
                                        description: "Add dates")
                }
            }
            .padding()
            .frame(height: selectedOption == .dates ? 120 : 64)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 10)
            .padding()
            .onTapGesture {
                withAnimation(.snappy) { selectedOption = .dates}
            }
            
            VStack {
                if selectedOption == .guests {
                    HStack{
                        Text("Expanded View")
                        
                        Spacer()
                    }
                }else{
                    CollapsedPickerView(title: "Who",
                                        description: "Add guests")
                }
            }
            .padding()
            .frame(height: selectedOption == .guests ? 120 : 64)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 10)
            .padding()
            .onTapGesture {
                withAnimation(.snappy) { selectedOption = .guests}
            }
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
