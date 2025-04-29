import SwiftUI

struct EditBiographyView: View {
    @ObservedObject var vm: ProfileViewModel
    @State private var text: String = ""

    var body: some View {
        VStack{
            UserEditDescriptionView(text: $text,
                                    title: title,
                                    description: description,
                                    buttonText: buttonText) {
                vm.updateUserBiography(bio: text)
            }
        }
        .onAppear {
            text = vm.user?.biography ?? ""
        }
        .presentationDetents([.height(400)])
    }
}

#Preview {
    EditBiographyView(vm: ProfileViewModel(
        authManager: AuthenticationManager(),
        userManager: UserManager()))
}

private extension EditBiographyView {
    
    var title: String {
        "What would your biography title be?"
    }
    
    var description: String {
        "If someone wrote a book about your life, what would they call it? Example: Born to Roam or Chonicles of a Dog Mum."
    }
    
    var buttonText: String {
        "My biography title would be:"
    }
}
