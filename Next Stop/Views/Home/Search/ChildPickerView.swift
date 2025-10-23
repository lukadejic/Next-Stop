import SwiftUI

struct ChildPickerView: View {
    let child: Int
    
    @State private var showPicker: Bool = false
    @State private var selectedOption: AgeOption = .lessThanOne
    @ObservedObject var vm : SearchDestinationsViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Child \(child + 1)")
            
            HStack{
                Text(selectedOption.rawValue)
                    .font(.footnote)
                    .foregroundStyle(.black.opacity(0.8))
                    .padding(10)
                
                Spacer()
                
                Button{
                    withAnimation(.snappy) {
                        showPicker.toggle()
                    }
                }label: {
                    Image("arrow.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(.horizontal,7)
                }
                
            }
            .background(RoundedRectangle(cornerRadius: 3)
                .stroke(lineWidth: 0.5))
            .frame(maxWidth: .infinity)
        }
        .sheet(isPresented: $showPicker) {
            PickerView(child: child,
                       selectedOption: $selectedOption,
                       vm: vm)
        }
    }
}

#Preview {
    ChildPickerView(child: 1,
                    vm: SearchDestinationsViewModel(
                        searchService: LocationSearchService()))
}
