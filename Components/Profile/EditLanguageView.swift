import SwiftUI

struct EditLanguageView: View {
    @ObservedObject var vm: ProfileViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    
                    UserLanguagesView(vm: vm)
                    
                    Spacer()
                }
                .navigationTitle("Lagnuages you speak")
            }
            .overlay(alignment: .bottom) {
                ButtonOverlay(text: "Save") {
                    vm.addUserLanguages(languages: vm.userLanguages)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    
    EditLanguageView(vm: ProfileViewModel(
        authManager: AuthenticationManager(),
        userManager: UserManager()))
}
