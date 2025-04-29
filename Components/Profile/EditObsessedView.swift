import SwiftUI

struct EditObsessedView: View {
    
    @ObservedObject var vm: ProfileViewModel
    @State private var text: String = ""
    
    var body: some View {
        VStack{
            UserEditDescriptionView(text: $text,
                                    title: title,
                                    description: description,
                                    buttonText: buttonText) {
                vm.updateObsessedUserText(text: text)
            }
        }
        .onAppear {
            text = vm.user?.obsessed ?? ""
        }
        .presentationDetents([.height(400)])
    }
}

#Preview {
    EditObsessedView(vm: ProfileViewModel(
        authManager: AuthenticationManager(),
        userManager: UserManager()))
}

private extension EditObsessedView {
    var title: String {
        "What are you obsessed with?"
    }
    
    var description: String {
        "Share whatever you can't ged enough of - in a good way.Example: Baking rosemary focaccia."
    }
    
    var buttonText: String {
        "I'm obsessed with:"
    }
}
