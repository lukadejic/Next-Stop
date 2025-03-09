import SwiftUI

struct PickerView: View {
    let child: Int
    @ObservedObject var vm : SearchDestinationsViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Child \(child)")
                .font(.title2)
                .fontWeight(.semibold)
            
            Picker("", selection: $vm.selectedOption) {
                ForEach(vm.options, id: \.self){ option in
                    Text(option).tag(option)
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
                    print(vm.selectedOption)
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
               vm: SearchDestinationsViewModel(searchService: LocationSearchService()))
}
