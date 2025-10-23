import SwiftUI

struct EditLocationView: View {
    @ObservedObject var vm: ProfileViewModel
    @StateObject private var locationVM = LocationSearchViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                
                if let selectedLocation = locationVM.selectedLocation {
                    Text("\(selectedLocation)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                }
                
                List(locationVM.searchResults, id: \.title) { result in
                    Text(result.title)
                        .onTapGesture {
                            locationVM.selectLocation(result.title)
                        }
                }
                .listStyle(PlainListStyle())
            }
            .onAppear{
                locationVM.selectedLocation = vm.user?.location ?? ""
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .searchable(text: $locationVM.searchText, prompt: "Enter your address")
            .onChange(of: locationVM.searchText) { _, newValue in
                if newValue.isEmpty {
                    locationVM.searchResults = []
                }
            }
            .overlay(alignment: .bottom) {
                ButtonOverlay(text: "Save") {
                    vm.updateUserLocation(location: locationVM.selectedLocation ?? "")
                    dismiss()
                }
            }
            .navigationTitle("Where you live")
        }
    }
}

#Preview {
    EditLocationView(vm: ProfileViewModel(
        authManager: AuthenticationManager(),
        userManager: UserManager()))
}
