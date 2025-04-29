import SwiftUI

struct EditPetsView: View {
    @ObservedObject var vm: ProfileViewModel
    @State private var text: String = ""

    var body: some View {
        VStack{
            UserEditDescriptionView(text: $text,
                                    title: title,
                                    description: description,
                                    buttonText: buttonText) {
                vm.updateUserPets(pets: text)
            }
        }
        .onAppear {
            text = vm.user?.pets ?? ""
        }
        .presentationDetents([.height(400)])
    }
}

#Preview {
    EditPetsView(vm: ProfileViewModel(
        authManager: AuthenticationManager(),
        userManager: UserManager()))
}

private extension EditPetsView {
    
    var title: String {
        "Do you have any pets in your life?"
    }
    
    var description: String {
        "Share any pets you have and their names. Example: My calcio cat Whiskers or my speedy tortise Leonardo"
    }
    
    var buttonText: String {
        "Pets:"
    }
}
