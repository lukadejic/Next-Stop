import SwiftUI

struct EditUserWorkView: View {
    @ObservedObject var vm: ProfileViewModel
    @State private var text: String = ""
    
    var body: some View {
        UserEditDescriptionView(text: $text,
                                title: title,
                                description: description,
                                buttonText: buttonText) {
            vm.updateUserWork(work: text)
        }
    }
}

#Preview {
    EditUserWorkView(vm: ProfileViewModel(
        authManager: AuthenticationManager(),
        userManager: UserManager()))
}

private extension EditUserWorkView {
    var title : String  {
        "What do you do for work?"
    }
    
    var description: String {
        "Tell us what you profession is.If you don't have a traditional job,tell us your life's calling.Example: Nurse, parent to four kids, or retired surfer."
    }
    
    var buttonText: String {
        "My work:"
    }
 }
