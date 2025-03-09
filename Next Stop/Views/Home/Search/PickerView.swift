import SwiftUI

struct PickerView: View {
    
    let child: Int
    @Environment(\.dismiss) var dismiss
    @Binding var selectedOption: AgeOption
    @ObservedObject var vm: SearchDestinationsViewModel
    @State private var tempOption: AgeOption
    
    init(child: Int,
         selectedOption: Binding<AgeOption>,
         vm: SearchDestinationsViewModel) {
        self.child = child
        self._selectedOption = selectedOption
        self._tempOption = State(initialValue: selectedOption.wrappedValue)
        self.vm = vm
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Child \(child)")
                .font(.title2)
                .fontWeight(.semibold)
            
            Picker("", selection: $tempOption) {
                ForEach(AgeOption.allCases, id: \.self){ option in
                    Text(option.rawValue)
                        .tag(option)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding(.bottom,80)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(maxHeight: .infinity)
        .padding()
        .presentationDetents([.height(300)])
        .presentationDragIndicator(.hidden)
        .overlay(alignment: .bottom) {
            VStack(spacing: 20) {
                Divider()
                
                Button {
                    selectedOption = tempOption
                    vm.childrenAges.append(selectedOption.age)
                    dismiss()
                } label: {
                    Text("Done")
                        .foregroundStyle(.white)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal, 20)
                }
            }
            .frame(maxWidth: .infinity)
            .background(.white)
            .shadow(radius: 5)
        }
        
    }
}

#Preview {
    PickerView(child: 1,
               selectedOption: .constant(.eight),
               vm: SearchDestinationsViewModel(
                searchService: LocationSearchService()))
}

private extension PickerView {
    func saveChoice() {
        
    }
}
